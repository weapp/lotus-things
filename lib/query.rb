require_relative "statement"

class Query
  attr_accessor :adapter, :statements, :statement_builder
  def initialize(adapter=nil, statement_builder=Statement)
    self.adapter = adapter
    self.statements = Hash.new()
    self.statement_builder = statement_builder
  end

  def statement clause, predicate, *opts
    self.statements[clause] ||= statement_builder.new(clause)
    self.statements[clause].add(predicate, *opts)
    self
  end

  def match *args
    statement :MATCH, *args
  end

  def optional_match *args
    statement :"OPTIONAL MATCH", *args
  end

  def where *args
    statement :WHERE, *args
  end

  def return *args
    statement :RETURN, *args
  end

  def return_node *fields
    fields.each do |field| 
      self.return("id(#{field}) as #{field}_id, labels(#{field}) as #{field}_labels, #{field}")
    end
    self
  end

  def return_rel *fields
    fields.each do |field| 
      self.return("id(#{field}) as #{field}_id, type(#{field}) as #{field}_type, #{field}")
    end
    self
  end

  def order_by *args
    statement :"ORDER BY", *args
  end

  def limit *args
    statement :LIMIT, *args
  end

  def execute
    adapter.execute_query(self)
  end

  def to_cypher
    s = sorted_statements.values.map(&:join).join(" ")
  end

  private
  CLAUSES = [:START, :MATCH, :"OPTIONAL MATCH", :CREATE, :WHERE, :WITH, :FOREACH, :SET, :DELETE, :REMOVE, :RETURN, :"ORDER BY", :SKIP, :LIMIT]

  def sorted_statements
    self.statements.sort_by { |clause, params| CLAUSES.index(clause) }.to_h
  end
end
