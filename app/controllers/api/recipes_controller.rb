class Api::RecipesController < ApplicationController

  def index
    if current_user
      @recipes = Recipe.where("title iLIKE ?", "%#{params[:search]}%")
      @recipes = @recipes.order(:id)
      render "index.json.jb"
    else
      render json: []
    end
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

  def update
    @recipe = Recipe.find_by(id: params[:id])

    @recipe.title = params[:title] || @recipe.title
    @recipe.ingredients = params[:ingredients] || @recipe.ingredients
    @recipe.directions = params[:directions] || @recipe.directions
    @recipe.chef = params[:chef] || @recipe.chef
    @recipe.prep_time = params[:prep_time] || @recipe.prep_time
    @recipe.image_url = params[:image_url] || @recipe.image_url

    @recipe.save
    render "show.json.jb"
  end

  def destroy
    recipe = Recipe.find_by(id: params[:id])
    recipe.destroy
    render json: {message: "Recipe successfully destroye!"}
  end

end
