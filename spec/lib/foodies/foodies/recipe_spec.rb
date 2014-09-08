require 'spec_helper'

describe Foodies::Recipe do

  let(:recipe_attrs) { 
    {
      "type" => "Recipe",
      # "author" => "John Smith", #person 
      "cook_time" => "PT1H",
      "date_published" => "2009-05-08",
      "description" => "This classic banana bread recipe comes from my mom -- the walnuts add a nice texture and flavor to the banana bread.",
      "image" => "bananabread.jpg",
      "ingredients" => [
        "3 or 4 ripe bananas, smashed", #ingredient
        "1 egg",
        "3/4 cup of sugar"
      ],
      "interaction_count" => "UserComments:140", #none
      "name" => "Mom's World Famous Banana Bread",
      # "nutrition" => {
      #   "@type" => "NutritionInformation",
      #   "calories" => "240 calories",
      #   "fatContent" => "9 grams fat"
      # },
      "prep_time" => "PT15M",
      "recipe_instructions" => "Preheat the oven to 350 degrees. Mix in the ingredients in a bowl. Add the flour last. Pour the mixture into a loaf pan and bake for one hour.",
      "recipe_yield" => "1 loaf"
    }
  }

  it { is_expected.to be_truthy }
  it { is_expected.to be_valid }

  it { expect(Foodies::Recipe.new({})).to be_valid }
  
  it { expect(Foodies::Recipe.new(recipe_attrs)).to be_valid }
  
  it { expect(Foodies::Recipe.new(recipe_attrs).attributes).to include(*recipe_attrs.keys) }

  it { expect(Foodies::Recipe.new().date_published).to match DateTime }

  # it { expect(recipe_attrs).to match Recipe.new(recipe_attrs).attributes }



end

