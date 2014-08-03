require 'minitest/autorun'
require 'minitest/rg'

require_relative 'predicate'

describe Predicate do

  describe ".new" do
    it "simple predicate is set" do
      p = Predicate.new("predicate")
      assert_equal "predicate", p.predicate
    end
  end

  describe ".build" do
    it "must create and generate a predicate" do
      assert_equal "predicate <'args'>", Predicate.build("predicate <?>", "args")
    end
  end

  describe "#generate" do
    it "string simple predicate is generated" do
      p = Predicate.new("predicate")
      assert_equal "predicate", p.generate
    end

    it "number predicate is generated" do
      p = Predicate.new(0)
      assert_equal "0", p.generate
    end

    it "symbol predicate is generated" do
      p = Predicate.new(:sym)
      assert_equal "sym", p.generate
    end

    it "hash predicate is generated" do
      p = Predicate.new(or: [["p1 ?", "args"], ["p2 <?> <?>", "arg1", "arg2"]])
      assert_equal "((p1 'args') OR (p2 <'arg1'> <'arg2'>))", p.generate
    end

    it "hash predicate is generated" do
      p = Predicate.new(or: ["p1", "p2"])
      assert_equal "((p1) OR (p2))", p.generate
    end

    it "string predicate with number is generated" do
      p = Predicate.new("predicate ?")
      assert_equal "predicate 0", p.generate(0)
    end

    it "string predicate with string is generated" do
      p = Predicate.new("predicate ?")
      assert_equal "predicate 'string'", p.generate("string")
    end

    it "string predicate with hash is generated" do
      p = Predicate.new("predicate ?")
      assert_equal "predicate {key : 'value'}", p.generate({key: "value"})
    end
  end

end