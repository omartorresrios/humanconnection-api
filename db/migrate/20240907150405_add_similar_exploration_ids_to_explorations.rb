class AddSimilarExplorationIdsToExplorations < ActiveRecord::Migration[7.1]
  def change
    add_column :explorations, :similar_exploration_ids, :text, array: true, default: []
  end
end
