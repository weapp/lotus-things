require_relative "./creative_work"

class Recipe < CreativeWork
  attribute :ingredients
  attribute :cook_time
  attribute :prep_time
  attribute :total_time
  attribute :recipe_instructions
  attribute :recipe_yield
end