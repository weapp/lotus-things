require_relative "predicate"

class Statement
  attr_accessor :predicates, :clause

  def initialize(clause)
    @clause = clause
    @predicates = []
  end

  def add(predicate, *opts)
    @predicates << Predicate.new(predicate).generate(*opts)
  end

  def join
    "#{clause} #{@predicates.join(separator)}"
  end

  def inspect
    @predicates.inspect
  end

  private
  def separator
    clause == :WHERE ? " and " : ", "
  end

end