require_relative "./creative_work"

module Foodies
  class Recipe < CreativeWork
    attribute :related_ingredients, default: []
    attribute :ingredients
    attribute :cook_time
    attribute :prep_time
    attribute :total_time
    attribute :recipe_instructions
    attribute :recipe_yield
  end

  def to_json
    puts "serialble!"
    puts "serialble!"
    puts "serialble!"
    puts "serialble!"
    puts "serialble!"
    puts "serialble!"
    puts "serialble!"
    puts "serialble!"
    puts "serialble!"
    puts "serialble!"
    puts "serialble!"
    puts "serialble!"
    puts "serialble!"
    puts "serialble!"
    puts "serialble!"
    super
  end
end