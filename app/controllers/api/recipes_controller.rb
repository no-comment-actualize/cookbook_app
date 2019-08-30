class Api::RecipesController < ApplicationController

  def index
    @recipes = Recipe.all
    render "index.json.jb"
  end

  def show
    @recipe = Recipe.find_by(id: params[:id]) #a recipe object/hash
    render "show.json.jb"
  end

  def create
    @recipe = Recipe.new(
      title: params[:title], 
      ingredients: params[:ingredients], 
      directions: params[:directions], 
      chef: params[:chef], 
      prep_time: params[:prep_time].to_i,
      image_url: params[:image_url]
    )
    @recipe.save
    render "show.json.jb"
  end

end
