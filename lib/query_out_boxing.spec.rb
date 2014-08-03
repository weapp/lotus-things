require 'minitest/autorun'
require 'minitest/rg'

require 'ostruct'

require_relative 'query'

describe Query do
  before do
    execute = ->(query){["first", "last"]}
    @q = Query.new(execute)
  end

  describe "#to_a" do
    it "must return array" do
      assert_kind_of Array, @q.to_a
    end
  end
  
  describe "#all" do
    it "must return array" do
      assert_equal ["first", "last"], @q.all
    end
  end

  describe "#call" do
    it "must return array" do
      assert_equal ["first", "last"], @q.()
    end
  end

  describe "#first" do
    it "must return array" do
      assert_equal "first", @q.first
    end
  end

  describe "#last" do
    it "must return array" do
      assert_equal "last", @q.last
    end
  end

end