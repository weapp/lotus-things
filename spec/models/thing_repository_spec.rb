require 'spec_helper'

describe ThingRepository do
  
  let(:thing){build_thing}
  
  let(:user){build_person}

  before do
    ThingRepository.clear
  end

  after do
    ThingRepository.clear
  end

  describe ".clear" do
    it "after must be empty" do
      ThingRepository.create(thing)
      ThingRepository.clear
      expect(ThingRepository.all).to be == []
    end
  end

  describe ".delete" do
    it "after must be empty" do
      ThingRepository.create(thing)
      ThingRepository.delete(thing)
      expect(ThingRepository.all).to be == []
    end
  end

  describe ".all" do
    it "must return all" do
      ThingRepository.create(thing)
      ThingRepository.create(user)
      expect(ThingRepository.all).to be == [thing, user]
    end
  end

  describe ".first" do
    it "must return first" do
      ThingRepository.create(thing)
      ThingRepository.create(user)
      expect(ThingRepository.first).to be == thing
    end
  end

  describe ".last" do
    it "must return last" do
      ThingRepository.create(thing)
      ThingRepository.create(user)
      expect(ThingRepository.last).to be == user
    end
  end

  describe ".create" do
    it "return same object" do
      ret = ThingRepository.create(thing)
      expect(ret).to be == thing
    end

    it "return object with id" do
      ret = ThingRepository.create(thing)
      expect(thing.id).to be_truthy
    end
  end

  describe ".find_by_name" do
    it "return same object" do
      ThingRepository.create(thing)
      ret = ThingRepository.find(thing.id)
      expect(ret).to be == thing
    end
  end

  describe ".find_by_name" do
    it "return same object" do
      ThingRepository.create(thing)
      ret = ThingRepository.find_by_name("Things")
      expect(ret).to be == thing
    end
  end

  describe ".director_movie" do
  end

  describe ".worlds" do
    it "return same object" do
      node = OpenStruct.new(serializable_hash: {name: "World"})
      ThingRepository.create(node)
      ret = ThingRepository.worlds
      expect(ret.first.id).to be == node.id
    end
  end

  # describe ".assign_creator" do
  # end

  # describe ".assign_updater" do
  # end

  describe ".create_with_creator" do
    it "return same object" do
      ThingRepository.create(user)
      ThingRepository.create_with_creator(thing, user)
      user = ThingRepository.created_by thing
      expect(user).to be == user
    end
  end
end

