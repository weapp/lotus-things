require 'lotus/model/mapper'

require 'foodies/recipe'
require 'foodies/ingredient'

require 'foodies/repositories/ingredient_repository'
require 'foodies/repositories/recipe_repository'
# require 'lotus/model/adapters/sql_adapter'
require 'lotus/model/adapters/neo4j_adapter'
require 'lotus/model/mapping/active_coercer'

module Foodies
  @@mapping = Lotus::Model::Mapper.new(Lotus::Model::Mapping::ActiveCoercer) do
    collection :recipe do
      entity     Foodies::Recipe
      repository Foodies::Repositories::RecipeRepository
    end

    collection :ingredient do
      entity     Foodies::Ingredient
      repository Foodies::Repositories::IngredientRepository
    end
  end

  def self.mapping
    @@mapping
  end

  def self.load!
    db_url = ENV['DATABASE_URL'] || "http://localhost:7474"
    adapter = Lotus::Model::Adapters::Neo4jAdapter.new(mapping, db_url)

    Foodies::Repositories::RecipeRepository.adapter = adapter
    Foodies::Repositories::IngredientRepository.adapter = adapter

    mapping.load!
  end
end