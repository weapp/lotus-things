require 'lotus/model/adapters/abstract'
require 'lotus/model/adapters/implementation'
require 'lotus/model/adapters/cypher/fake_collection'
require 'lotus/model/adapters/cypher/collection'
require 'lotus/model/adapters/cypher/command'
require 'lotus/model/adapters/cypher/query'

require 'headjack'

module Lotus
  module Model
    module Adapters
      class Neo4jAdapter < Abstract
        include Implementation

        def initialize(mapper, uri="http://localhost:7474", connection = Headjack::Connection)
          super(mapper, uri)
          @connection = connection.new(url: uri)#, bodylog: true)
        end

        def create(collection, entity)
          entity.id = command(
                        query(collection)
                      ).create(entity)
          entity
        end

        def update(collection, entity)
          command(
            _find(collection, entity.id)
          ).update(entity)
          entity
        end
        
        def delete(collection, entity)
          command(
            _find(collection, entity.id)
          ).delete
        end

        def clear(collection)
          command(query(collection)).clear
        end

        def create_relationship(collection, role, node1, node2, attrs={})
          command(
            query(collection)
              .no_sort
              .match("(a {id: ?})", node1.id)
              .match("(b {id: ?})", node2.id)
              .create("(a)-[r:#{role} ?]->(b)", attrs)
              .return("r")
          )
        end

        def command(query)
          Cypher::Command.new(query)
        end

        def query(collection, context = nil, &blk)
          Cypher::Query.new(_collection(collection), context, &blk)
        end

        private

        def _collection(name)
          Cypher::Collection.new(Cypher::FakeCollection.new(@connection, name), _mapped_collection(name))
        end

      end
    end
  end
end
