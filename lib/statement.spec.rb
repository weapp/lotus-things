require 'minitest/autorun'
require 'minitest/rg'

require_relative 'statement'

describe Statement do

  describe ".new" do
    it "clause is set" do
      s = Statement.new(:MATCH)
      assert_equal :MATCH, s.clause
    end
  end

  describe "#add" do
    before do
      @statement = Statement.new(:MATCH)
    end

    it "predicate can be added" do
      @statement.add("predicate")
      assert_equal ["predicate"], @statement.predicates
    end

    it "complex predicate can be added" do
      @statement.add("predicate ?", 0)
      assert_equal ["predicate 0"], @statement.predicates
    end

    it "multiple predicates can be added" do
      @statement.add("predicate ?", 0)
      @statement.add("predicate ?", 1)
      assert_equal ["predicate 0", "predicate 1"], @statement.predicates
    end
  end

  describe "#join" do
    it "predicates must be separted by comma" do
      @statement = Statement.new(:MATCH)
      @statement.add("predicate 1")
      @statement.add("predicate 2")
      assert_equal "MATCH predicate 1, predicate 2", @statement.join
    end

    it "predicates must be separted by and if caluse is where" do
      @statement = Statement.new(:WHERE)
      @statement.add("predicate 1")
      @statement.add("predicate 2")
      assert_equal "WHERE predicate 1 and predicate 2", @statement.join
    end
  end

end