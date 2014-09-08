require 'cypherites'
require 'macaddr'
require 'lotus/utils/hash'
require "deep_dive"

module Lotus
  module Model
    module Adapters
      module Cypher
        class FakeCollection
          extend Forwardable
          include DeepDive

          def_delegators :@logger, :debug, :info, :warn, :error, :fatal
          def_delegators :execute, :map, :to_a
          def_delegators :@query, :no_sort

          attr_accessor :query, :return


          def initialize(connection, collection)
            @connection, @collection = connection, collection
            
            @query = q.match("(node#{c @collection})")

            @return = true

            @logger = begin
              require 'logger'
              ::Logger.new(STDOUT)
            end

            @logger = Object.new.tap do |o|
              def o.debug *args; end
              def o.info *args; end
              def o.warn *args; end
              def o.error *args; end
              def o.fatal *args; end
            end

            debug " > new #{@collection.inspect}"
          end

          def insert hsh
            debug " > insert #{hsh} in #{@collection.inspect}"

            id = hsh["id"] = oid

            hsh.each {|k, v| hsh.delete(k) if v.nil? }

            @connection.(
              query: q.create("(node#{c @collection} {props})"), 
              parameters: {props: hsh}
            )

            id
          end

          def where hsh
            debug " > where #{hsh} in #{@collection.inspect}"

            mq do
              hsh.each do |k, v|
                if k.to_s.include? "."
                  where("#{k} = ?", v)
                else
                  where("node.#{k} = ?", v)
                end
              end
            end
          end

          def match args
            mq{match *args}
          end

          def create *args
            mq{create *args}
          end

          def start *args
            mq{start *args}
          end

          def return *args
            mq{self.return *args}
          end

          def update hsh
            debug " > update #{hsh} in #{@collection.inspect}"
            id = hsh["id"]
            @connection.(
              query: q.match("(node {id: {id}})").set("node = {props}"),
              parameters: {
                id: id,
                props: hsh
              }
            )
            hsh
            id
          end

          def limit n
            mq{limit(n)}
          end

          def order key
            field, order = Array(key)
            debug " > order #{field} in #{@collection.inspect}"
            mq{order("node.#{field} #{order.to_s.upcase}")}
          end

          def delete
            debug " > delete in #{@collection.inspect}"

            @query
              .optional_match("(node)-[relation]-()")
              .delete("node")
              .delete("relation")

            @return = false

            @connection.(query: @query)
            
            true
          end


          def execute
            mq.execute!
          end

          def execute!
            @query.return("node") if @return
            @return = false
            @connection.(query: @query).map{|hsh| Lotus::Utils::Hash.new(hsh).symbolize!}
          end

          private

          BYTES3 = 1 << (3 * 8)
          def counter()
            @@counter ||= rand(BYTES3)
            @@counter =  (@@counter + 1) % BYTES3
            @@counter.to_s(16)
          end

          def oid(time = Time.now)
            t = time.to_i.to_s(16)
            m = Mac.addr[-4,4].gsub(":","") rescue ""
            p = Process.pid.to_i.to_s(16)
            c = counter()
            "%s%s%s%s" % [t , m.rjust(6, '0') , p.rjust(4, '0') , c.rjust(6, '0')]
          end

          def mq &block
            self.tap do | fake_coll |
              fake_coll.query.instance_eval(&block) if block_given?
            end
          end

          def q
            Cypherites::Query.new
          end

          def c collection, opts={}
            # raise ArgumentError.new("collection is nil") unless collection
            name = ""
            name << ":" if !opts[:only_name]
            name << collection.to_s.capitalize
            name if collection
          end

        end
      end
    end
  end
end