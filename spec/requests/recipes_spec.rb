require 'rails_helper'

RSpec.describe "Recipes", type: :request do
  describe "GET /recipes" do
    it "should return an array of all recipes" do

      user = User.create(name: "Dani", email: "dani@gmail.com", password: "password")
      Recipe.create(title: "Example Recipe 1", prep_time: 5, ingredients: "...", directions: "...", user_id: user.id)
      Recipe.create(title: "Example Recipe 2", prep_time: 5, ingredients: "...", directions: "...",user_id: user.id)
      Recipe.create(title: "Example Recipe 3", prep_time: 5, ingredients: "...", directions: "...",user_id: user.id)

      get "/api/recipes"
      # response.body is a giant string, JSON.parse parses the string for us
      recipes = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(recipes.length).to eq(3)
    end
  end
end
