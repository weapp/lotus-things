module Lotus
  module Model
    module Mapping
      class ActiveCoercer

        def initialize(collection)
          @collection = collection
        end

        def to_record(entity)
          entity.serializable_hash.tap do |hsh|
            hsh["type"] = entity.class.to_s
          end
        end

        def from_record(record)
          get_class(record["type"]).new(record)
        end

        def deserialize_id id
          id
        end

        # def method_missing method_name, *args
        #   if method_name =~ /^deserialize_/
        #     # puts " > #{method_name} -> #{args.first}"
        #     args.first
        #   else
        #     super
        #   end
        # end

        private
        def get_class class_name
          Lotus::Utils::Class.load!(record["type"]) rescue @collection.entity 
        end
      end
    end
  end
end