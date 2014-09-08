require 'bundler/setup'
require 'binding_of_caller'

require "foodies"

Foodies.load!


def ev string
  line = caller.last.reverse.split(":", 2).last.reverse # ruby hasnt rsplit
  puts "#{line} => #{string}"

  res = binding.of_caller(1).eval string
  puts
  puts " = #{res.inspect}"
  puts
  puts
end


ingrs = []
ingrs << Foodies::Ingredient.new(name: "Tomato")
# ingrs << Foodies::Ingredient.new(name: "Water")
# ingrs << Foodies::Ingredient.new(name: "Olive Oil")
# ingrs << Foodies::Ingredient.new(name: "Flour")
# ingrs << Foodies::Ingredient.new(name: "Salt")
# ingrs << Foodies::Ingredient.new(name: "Sugar")
# ingrs << Foodies::Ingredient.new(name: "Pesto")
# ingrs << Foodies::Ingredient.new(name: "Onions")

r = Foodies::Recipe.new(name: "Pizza")


ev "Foodies::Repositories::IngredientRepository.clear"
ev "Foodies::Repositories::RecipeRepository.clear"


ingrs.each do |i|
  ev "Foodies::Repositories::IngredientRepository.create(i)"
  ev "r.related_ingredients << i"
end 

ev "Foodies::Repositories::RecipeRepository.create(r)"

exit

# Pizza Dough: Makes enough dough for two 10-12 inch pizzas
# 1 1/2 cups warm water (105°F-115°F)
# 1 package (2 1/4 teaspoons) of active dry yeast
# 3 1/2 cups bread flour
# 2 Tbsp olive oil
# 2 teaspoons salt
# 1 teaspoon sugar

# Pizza Ingredients
# Olive oil
# Cornmeal (to help slide the pizza onto the pizza stone)
# Tomato sauce (smooth, or puréed)
# Mozzarella cheese, grated
# Parmesan cheese, grated
# Feta cheese, crumbled
# Mushrooms, thinly sliced
# Bell peppers, stems and seeds removed, thinly sliced
# Italian sausage, cooked ahead and crumbled
# Chopped fresh basil
# Pesto
# Pepperoni, thinly sliced
# Onions, thinly sliced
# Ham, thinly sliced

# Special equipment needed
# A pizza stone, highly recommended if you want crispy pizza crust
# A pizza peel or a flat baking sheet
# A pizza wheel for cutting the pizza, not required, but easier to deal with than a knife

ev "Foodies::Repositories::RecipeRepository.create(r)"
ev "Foodies::Repositories::RecipeRepository.persist(r)"
r.name = "Hamburguer"
ev "Foodies::Repositories::RecipeRepository.update(r)"
ev "Foodies::Repositories::RecipeRepository.all"
ev "Foodies::Repositories::RecipeRepository.all.count"
ev "Foodies::Repositories::RecipeRepository.find(r.id)"
ev "Foodies::Repositories::RecipeRepository.first"
ev "Foodies::Repositories::RecipeRepository.last"
# ev "Foodies::Repositories::RecipeRepository.send(:query).where(a: :b).scoped"
ev "Foodies::Repositories::RecipeRepository.delete(r)"
ev "Foodies::Repositories::RecipeRepository.clear"
ev "Foodies::Repositories::RecipeRepository.persist(r)"
ev "Foodies::Repositories::RecipeRepository.persist(r)"