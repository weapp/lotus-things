require 'lotus/model'
require './lib/neo4_j_adapter'

class ThingRepository
  include Lotus::Repository
  self.adapter = Neo4JAdapter.new
  self.collection = "things"
end