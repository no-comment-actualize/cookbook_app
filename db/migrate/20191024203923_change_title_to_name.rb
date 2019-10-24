class ChangeTitleToName < ActiveRecord::Migration[6.0]
  def change
    rename_column :recipes, :title, :name
  end
end
