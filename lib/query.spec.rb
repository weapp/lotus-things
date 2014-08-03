require 'minitest/autorun'
require 'minitest/rg'

require 'ostruct'

require_relative 'query'

describe Query do

  describe ".new" do
    it "adapter is set" do
      adapter = OpenStruct.new
      q = Query.new(adapter)
      assert_equal adapter, q.adapter
    end

    it "adapter is optional" do
      q = Query.new()
    end
  end

  describe "#statement" do

    it "must return itself" do
      @q = Query.new
      assert_equal @q, @q.statement(:MATCH, "predicate")
    end
    
    it "must store the statement" do
      q = Query.new
      q.statement(:MATCH, "predicate")
      statements = q.statements
      assert_equal(:MATCH, statements.keys.first)
      assert_equal(["predicate"], statements.values.first.predicates)
    end
  end

  common_clauses = %w{match optional_match where return order_by limit}

  common_clauses.each do |clause|
    describe "##{clause}" do
      it "must return itself" do
        q = Query.new
        assert_equal q, q.send(clause, "predicate")
      end

      it "must call #statement with correct symbol" do
        sym = clause.upcase.gsub(/_/, " ").to_sym
        q = Query.new
        st_build_mock = MiniTest::Mock.new
        q.statement_builder = st_build_mock
        st_build_mock.expect(:new, Statement.new(sym), [sym])
        q.send(clause, "predicate")
        assert(st_build_mock.verify)
      end
    end
  end

  describe "#return_node" do
    it "must return itself" do
      q = Query.new
      assert_equal q, q.return_node("node1")
    end

    it "must call #statement with correct symbol" do
        q = Query.new
        st_build_mock = MiniTest::Mock.new
        q.statement_builder = st_build_mock
        q.statement_builder.expect(:new, Statement.new(:RETURN), [:RETURN])
        q.return_node("node1")
        assert(st_build_mock.verify)
    end
  end

  describe "#return_rel" do
    it "must return itself" do
      q = Query.new
      assert_equal q, q.return_rel("rel")
    end

    it "must call #statement with correct symbol" do
      q = Query.new
        st_build_mock = MiniTest::Mock.new
        q.statement_builder = st_build_mock
      q.statement_builder.expect(:new, Statement.new(:RETURN), [:RETURN])
      q.return_rel("rel")
      assert(st_build_mock.verify)
    end
  end

  describe "#to_cypher" do
    it "returned sorted statements" do
      q = Query.new
        .limit("")
        .match("")
        .order_by("")
        .optional_match("")
        .return("")
        .start("")
        .where("")

      assert_equal "START  MATCH  OPTIONAL MATCH  WHERE  RETURN  ORDER BY  LIMIT ", q.to_cypher
    end

    it "example query must work" do
      q = Query.new
        .limit(10)
        .match("(object ?)", {key: "value"})
        .order_by(:id)
        .optional_match("(object)->[r]->()")
        .return("id(object) as id")
        .return("object")
        .return("r")
        .start("object = node(?)", 1)
        .where(or: [["object.field = ?", "value"], ["wadus = ?", "fadus"]])
        .where("object.field = ?", "value")
        .where("object.field2 = ?", "value2")

      result = [
        "START object = node(1)",
        "MATCH (object {key : 'value'})",
        "OPTIONAL MATCH (object)->[r]->()",
        "WHERE ((object.field = 'value') OR (wadus = 'fadus'))",
               "and object.field = 'value' and object.field2 = 'value2'",
        "RETURN id(object) as id, object, r",
        "ORDER BY id",
        "LIMIT 10"
      ]

      assert_equal result.join(" "), q.to_cypher
    end
  end

end