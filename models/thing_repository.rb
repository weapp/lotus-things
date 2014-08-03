require 'lotus/model'
require './lib/neo4_j_adapter'

class ThingRepository
  include Lotus::Repository
  self.adapter = Neo4JAdapter.new
  self.collection = "things"

  def self.find_by_name name
    find_match({name: name}).execute.first
  end

  def self.after_400
    q = query
      .match("(?)", :object)
      .where("id(?) > ?", :object, 400)
      .optional_match("(?)-[?]->(?)", :object, :r, :other)
      .return_node(:object, :other)
      .return_rel(:r)
      .order_by("id(?) ?", :object, :DESC)
      .limit(20)
    q.execute
  end

  def self.director_movie
    query
      .match("(director)-[:DIRECTED]->(movie)")
      .return_node("movie")
      .return_node("director")
      .limit(2)
      .execute
  end


  def self.worlds
    query
      .match("(object)")
      .where("object.name = \"World\"")
      .return_node("object")
      .limit(100)
      .execute
  end


  def self.assign_creator thing, user, time = Time.now
    # rel = @adapter.create_relationship("created_by", thing, user)
    # @adapter.set_relationship_properties(rel, {"at" => time})

    rel = @adapter.create_relationship("created", user, thing)
    @adapter.set_relationship_properties(rel, {"at" => time})

    assign_updater thing, user, time
  end

  def self.assign_updater thing, user, time = Time.now
    # rel = @adapter.create_relationship("updated_by", thing, user)
    # @adapter.set_relationship_properties(rel, {"at" => time})

    rel = @adapter.create_relationship("updated", user, thing)
    @adapter.set_relationship_properties(rel, {"at" => time})
  end

  def self.create_with_creator thing, user
    create thing
    assign_creator thing, user
  end

  private

  def self.search_match(obj)
    query
      .match("(? ?)", :object, obj)
      .return_node(:object)
  end

  def self.find_match(obj)
    search_match(obj).limit(1)
  end

end