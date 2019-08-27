class Api::RecipesController < ApplicationController

  def one_recipe_action
    @recipe = Recipe.first #a recipe object/hash
    render 'one_recipe.json.jb'
  end

end
