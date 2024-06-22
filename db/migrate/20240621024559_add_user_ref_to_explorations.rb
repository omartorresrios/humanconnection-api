class AddUserRefToExplorations < ActiveRecord::Migration[7.1]
  def change
    add_reference :explorations, :user, null: false, foreign_key: true
  end
end
