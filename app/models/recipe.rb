class Recipe < ApplicationRecord

  validates :title, :ingredients, :directions, presence: true
  validates :prep_time, numericality: { greater_than: 0 }

  belongs_to :user

  def ingredients_list
    ingredients.split(", ")
  end

  def directions_list
    directions.split(", ")
  end

  def friendly_created_at
    created_at.strftime("%A, %d %b %Y %l:%M %p")
  end

  def friendly_prep_time
    hours = prep_time / 60
    minutes = prep_time % 60
    result = ""
    result += "#{hours} hours " if hours > 0
    result += "#{minutes} minutes" if minutes > 0
    result
  end

end