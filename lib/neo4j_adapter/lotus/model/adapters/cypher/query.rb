require 'forwardable'
require 'lotus/utils/kernel'

module Lotus
  module Model
    module Adapters
      module Cypher
        class Query
          OPERATORS_MAPPING = {
            where:   :exclude,
            exclude: :where
          }.freeze

          include Enumerable
          extend  Forwardable

          def_delegators :all, :each, :to_s, :empty?

          attr_reader :conditions

          def initialize(collection, context = nil, &blk)
            @collection, @context = collection, context
            @conditions = []

            instance_eval(&blk) if block_given?
          end

          def all
            Lotus::Utils::Kernel.Array(run)
          end

          def where(condition=nil, &blk)
            condition = (condition or blk or raise ArgumentError.new('You need to specify an condition.'))
            conditions.push([:where, condition])
            self
          end

          def no_sort
            @collection.no_sort
            self
          end

          def create *args
            @collection.create *args
            self
          end

          def start *args
            @collection.start *args
            self
          end

          def return *args
            @collection.return *args
            self
          end

          def match(*condition, &blk)
            condition = (condition or blk or raise ArgumentError.new('You need to specify an condition.'))
            conditions.push([:match, condition])
            self
          end

          alias_method :and, :where

          def or(condition=nil, &blk)
            condition = (condition or blk or raise ArgumentError.new('You need to specify an condition.'))
            conditions.push([:or, condition])
            self
          end

          def exclude(condition=nil, &blk)
            condition = (condition or blk or raise ArgumentError.new('You need to specify an condition.'))
            conditions.push([:exclude, condition])
            self
          end

          alias_method :not, :exclude

          def select(*columns)
            conditions.push([:select, *columns])
            self
          end

          def limit(number)
            conditions.push([:limit, number])
            self
          end

          def offset(number)
            conditions.push([:offset, number])
            self
          end

          def order(*columns)
            conditions.push([_order_operator, *columns])
            self
          end

          alias_method :asc, :order

          def desc(*columns)
            Array(columns).each do |column|
              conditions.push([_order_operator, [column, :desc]] ) # Sequel.desc(column)
            end

            self
          end

          def sum(column)
            run.sum(column)
          end

          def average(column)
            run.avg(column)
          end

          alias_method :avg, :average

          def max(column)
            run.max(column)
          end

          def min(column)
            run.min(column)
          end

          def interval(column)
            run.interval(column)
          end

          def range(column)
            run.range(column)
          end

          def exist?
            !count.zero?
          end

          def count
            run.count
          end

          def negate!
            conditions.map! do |(operator, condition)|
              [OPERATORS_MAPPING.fetch(operator) { operator }, condition]
            end
          end

          def scoped
            scope = @collection

            conditions.each do |(method,*args)|
              scope = scope.public_send(method, *args)
            end

            @conditions = []

            scope
          end

          alias_method :run, :scoped

          protected
          def method_missing(m, *args, &blk)
            if @context.respond_to?(m)
              apply @context.public_send(m, *args, &blk)
            else
              super
            end
          end

          private

          def apply(query)
            dup.tap do |result|
              result.conditions.push(*query.conditions)
            end
          end

          def _order_operator
            if conditions.any? {|c, _| c == :order }
              :order_more
            else
              :order
            end
          end
        end
      end
    end
  end
end