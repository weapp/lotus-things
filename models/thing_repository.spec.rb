require 'ostruct'
require 'minitest/autorun'

require 'minitest/rg'

require_relative 'thing_repository'
require_relative 'thing'
require_relative 'person'

describe ThingRepository do
  before do
    ThingRepository.clear

    @thing = Thing.new(
      name: "Things",
      alternate_name: "thingsapp",
      description: "ruby app",
      image: nil,
      url: "https://thingsapp.com/",
      same_as: "https://twitter.com/things",
      slug: "things",
    )

    @user = Person.new(
      name: "Manuel",
      alternate_name: "Manu",
      description: "ruby developer",
      image: "https://avatars2.githubusercontent.com/u/856974",
      url: "https://github.com/weapp",
      same_as: "https://twitter.com/weapp",
      slug: "manu",
    )
    
  end

  after do
    ThingRepository.clear
  end

  describe ".clear" do
    it "after must be empty" do
      ThingRepository.create(@thing)
      ThingRepository.clear
      assert_equal [], ThingRepository.all
    end
  end

  describe ".delete" do
    it "after must be empty" do
      ThingRepository.create(@thing)
      ThingRepository.delete(@thing)
      assert_equal [], ThingRepository.all
    end
  end

  describe ".all" do
    it "must return all" do
      ThingRepository.create(@thing)
      ThingRepository.create(@user)
      assert_equal [@thing, @user], ThingRepository.all
    end
  end

  describe ".first" do
    it "must return first" do
      ThingRepository.create(@thing)
      ThingRepository.create(@user)
      assert_equal @thing, ThingRepository.first
    end
  end

  describe ".last" do
    it "must return last" do
      ThingRepository.create(@thing)
      ThingRepository.create(@user)
      assert_equal @user, ThingRepository.last
    end
  end

  describe ".create" do
    it "return same object" do
      ret = ThingRepository.create(@thing)
      assert_equal @thing, ret
    end

    it "return object with id" do
      ret = ThingRepository.create(@thing)
      refute_nil @thing.id
    end
  end

  describe ".find_by_name" do
    it "return same object" do
      ThingRepository.create(@thing)
      ret = ThingRepository.find(@thing.id)
      assert_equal @thing, ret
    end
  end

  describe ".find_by_name" do
    it "return same object" do
      ThingRepository.create(@thing)
      ret = ThingRepository.find_by_name("Things")
      assert_equal @thing, ret
    end
  end

  describe ".director_movie" do
  end

  describe ".worlds" do
    it "return same object" do
      thing = OpenStruct.new(serializable_hash: {name: "World"})
      ThingRepository.create(thing)
      ret = ThingRepository.worlds
      assert_equal thing.id, ret.first.id
    end
  end

  # describe ".assign_creator" do
  # end

  # describe ".assign_updater" do
  # end

  describe ".create_with_creator" do
    it "return same object" do
      ThingRepository.create(@user)
      ThingRepository.create_with_creator(@thing, @user)
      user = ThingRepository.created_by @thing
      assert_equal @user, user
    end
  end
end

