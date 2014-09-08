require 'delegate'
require 'lotus/utils/kernel' unless RUBY_VERSION >= '2.1'

module Lotus
  module Model
    module Adapters
      module Cypher
        class Collection < SimpleDelegator
          def initialize(dataset, collection)
            super(dataset)
            @collection = collection
          end

          def exclude(*args)
            Collection.new(super, @collection)
          end

          def insert(entity)
            super _serialize(entity)
          end

          def limit(*args)
            Collection.new(super, @collection)
          end

          def offset(*args)
            Collection.new(super, @collection)
          end

          def or(*args)
            Collection.new(super, @collection)
          end

          def order(*args)
            Collection.new(super, @collection)
          end

          def order_more(*args)
            Collection.new(super, @collection)
          end

          if RUBY_VERSION >= '2.1'
            def select(*args)
              Collection.new(super, @collection)
            end
          else
            def select(*args)
              Collection.new(__getobj__.select(*Lotus::Utils::Kernel.Array(args)), @collection)
            end
          end

          def where(*args)
            Collection.new(super, @collection)
          end

          def match(*args)
            Collection.new(super, @collection)
          end

          def create(*args)
            Collection.new(super, @collection)
          end

          def start(*args)
            Collection.new(super, @collection)
          end

          def return(*args)
            Collection.new(super, @collection)
          end

          def update(entity)
            super _serialize(entity)
          end

          def to_a
            @collection.deserialize(self)
          end

          private
          def _serialize(entity)
            @collection.serialize(entity)
          end
        end
      end
    end
  end
end