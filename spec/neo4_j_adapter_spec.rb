require 'spec_helper'

describe Neo4JAdapter do

  before do
    @neo_adapter = Neo4JAdapter.new
    @collection = nil
    @repository = nil
    @neo_adapter.clear @collection    
  end

  after do
    neo_adapter.clear @collection
  end

  # null for params
  let(:collection){@collection}
  let(:repository){@repository}
  
  let(:neo_adapter){@neo_adapter}

  let(:thing){build_thing}
  let(:user){build_person}

  describe "#persist" do
    it "must create if object not exist"
    it "must update if object exist"
  end

  describe "#create" do
    it "return same object" do
      ret = neo_adapter.create(collection, thing)
      expect(ret).to be thing
    end

    it "return object with id" do
      ret = neo_adapter.create(collection, thing)
      expect(thing.id).to be_truthy
    end
  end

  describe "#update" do
    it "must save object"
  end

  describe "#delete" do
    it "after must be empty" do
      neo_adapter.create(collection, thing)
      neo_adapter.delete(collection, thing)
      expect(neo_adapter.all collection).to eq []
    end
  end

  describe "#all" do
    it "must return all" do
      neo_adapter.create(collection, thing)
      neo_adapter.create(collection, user)
      expect(neo_adapter.all collection).to eq [thing, user]
    end
  end

  describe "#find" do
    it "return a equal object"
  end

  describe "#first" do
    it "must return first" do
      neo_adapter.create(collection, thing)
      neo_adapter.create(collection, user)
      expect(neo_adapter.first collection).to eq thing
    end
  end

  describe "#last" do
    it "must return last" do
      neo_adapter.create(collection, thing)
      neo_adapter.create(collection, user)
      expect(neo_adapter.last collection).to eq user
    end
  end

  describe "#clear" do
    it "after must be empty" do
      neo_adapter.create(collection, thing)
      neo_adapter.clear collection
      expect(neo_adapter.all collection).to eq []
    end
  end

  describe "#query" do
    it "return a Query object" do
      q = neo_adapter.query collection, repository
      expect(q).to be_a Cypherites::Query
    end
  end
end
