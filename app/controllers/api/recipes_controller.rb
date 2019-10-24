class Api::RecipesController < ApplicationController

  before_action :authenticate_user, only: [:create]

  def index
    @recipes = Recipe.all
    # if current_user
    #   @recipes = Recipe.where("title iLIKE ?", "%#{params[:search]}%")
    #   @recipes = @recipes.order(:id)
    render "index.json.jb"
    # else
    #   render json: []
    # end
  end

  def show
    @recipe = Recipe.find_by(id: params[:id]) #a recipe object/hash
    render "show.json.jb"
  end

  def create
    if params[:image]
      response = Cloudinary::Uploader.upload(params[:image])
      cloudinary_url = response["secure_url"]
    end
    @recipe = Recipe.new(
      title: params[:title], 
      ingredients: params[:ingredients], 
      directions: params[:directions], 
      prep_time: params[:prep_time].to_i,
      image_url: cloudinary_url || "default.jpg",
      user_id: current_user.id
    )
    if @recipe.save
      render "show.json.jb"
    else
      render json: {errors: @recipe.errors.full_messages}, status: 422
    end
  end

  def update
    @recipe = Recipe.find_by(id: params[:id])

    @recipe.title = params[:title] || @recipe.title
    @recipe.ingredients = params[:ingredients] || @recipe.ingredients
    @recipe.directions = params[:directions] || @recipe.directions
    @recipe.prep_time = params[:prep_time] || @recipe.prep_time
    @recipe.image_url = params[:image_url] || @recipe.image_url

    if @recipe.save
      render "show.json.jb"
    else
      render json: {errors: @recipe.errors.full_messages}, status: 422
    end
  end

  def destroy
    recipe = Recipe.find_by(id: params[:id])
    recipe.destroy
    render json: {message: "Recipe successfully destroyed!"}
  end

end
