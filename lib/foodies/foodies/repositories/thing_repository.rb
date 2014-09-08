require 'lotus/model'
# require './lib/neo4_j_adapter'

class ThingRepository
  include Lotus::Repository
  # self.adapter = Neo4JAdapter.new(nil)
  # self.collection = "things"

  def self.find_by_name name
    search_match({name: name}).first
  end

  def self.after_400
    q = query
      .match("(?)", :node)
      .where("id(?) > ?", :node, 400)
      .optional_match("(?)-[?]->(?)", :node, :r, :other)
      .return_node(:node, :other)
      .return_rel(:r)
      .order_by("id(?) ?", :node, :DESC)
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
    # query
    #   .match("(node)")
    #   .where(name: "World")
    #   .limit(100)
    #   .scoped
      # .execute
      # .return_node("node")
    query
      .match("(node {name: 'World'})")
      .limit(100)

  end


  def self.assign_creator thing, user, time = Time.now
    # rel = @adapter.create_relationship("created_by", thing, user)
    # @adapter.set_relationship_properties(rel, {"at" => time})

    rel = @adapter.create_relationship(collection, "CREATED", user, thing, {"at" => time.to_s})

    assign_updater thing, user, time
  end

  def self.assign_updater thing, user, time = Time.now
    # rel = @adapter.create_relationship("updated_by", thing, user)
    # @adapter.set_relationship_properties(rel, {"at" => time})

    rel = @adapter.create_relationship(collection, "UPDATED", user, thing, {"at" => time.to_s})
  end

  def self.create_with_creator thing, user
    create thing
    assign_creator thing, user
  end

  def self.created_by thing
    query
      .match("(node {id: ?})<-[CREATED]-(user)", thing.id.to_i)
      .first
  end

  private

  def self.search_match(obj)
    query
      .match("(node ?)", obj)
      # .return_node(:node)
  end

end