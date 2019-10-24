require 'rails_helper'

RSpec.describe "Recipes", type: :request do

  before do
    user = User.create(name: "Cheddar", email: "cheddar@gmail.com", password: "password")
    Recipe.create(title: "Recipe 1", prep_time: 5, ingredients: "Ingredient 1, Ingredient 2", directions: "Direction 1, Direction 2", user_id: user.id)
    Recipe.create(title: "Recipe 2", prep_time: 10, ingredients: "Ingredient 1, Ingredient 2", directions: "Direction 1, Direction 2", user_id: user.id)
    Recipe.create(title: "Recipe 3", prep_time: 11, ingredients: "Ingredient 1, Ingredient 2", directions: "Direction 1, Direction 2", user_id: user.id)
  end

  describe "GET /recipes" do
    it "should return an array of all recipes" do
      get "/api/recipes"
      # response.body is a giant string, JSON.parse parses the string for us
      recipes = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(recipes.length).to eq(3)
    end
  end

  describe "GET /recipes/:id" do
    it "should return a hash with the appropriate attributes" do
      recipe_id = Recipe.first.id
      get "/api/recipes/#{recipe_id}"
      recipe = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(recipe["title"]).to eq("Recipe 1")
      expect(recipe["prep_time"]).to eq(5)
    end
  end
  describe "POST /recipes" do
    it "creates a recipe" do
      jwt = JWT.encode({user_id: User.first.id}, Rails.application.credentials.fetch(:secret_key_base),'HS256')
      post "/api/recipes", 
      params: {
        title: "New title",
        ingredients: "New ingredients",
        directions: "New directions",
        prep_time: 100
      },
      headers: {
        Authorization: "Bearer #{jwt}"
      }
      recipe = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(recipe["title"]).to eq("New title")
    end
    it "returns an unauthorized status without a jwt" do
      post "/api/recipes",
      params: {},
      headers: {}
      expect(response).to have_http_status(:unauthorized)     
    end
    it "returns an error status with invalid data with a jwt" do
      jwt = JWT.encode({user_id: User.first.id}, Rails.application.credentials.fetch(:secret_key_base),'HS256')
      post "/api/recipes",
      params: {},
      headers: {
        Authorization: "Bearer #{jwt}"
      }
      expect(response).to have_http_status(422)     
    end
  end
  describe "PATCH /recipes/:id" do
    it "updates a recipe" do
      jwt = JWT.encode({user_id: User.first.id}, Rails.application.credentials.fetch(:secret_key_base),'HS256')
      recipe_id = Recipe.first.id

      patch "/api/recipes/#{recipe_id}",
      params: {
        title: "Updated Recipe Title"
      },
      headers: {
        Authorization: "Bearer #{jwt}"
      }
      recipe = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(recipe["title"]).to eq("Updated Recipe Title")
      expect(recipe["prep_time"]).to eq(5)
    end
  end
end
