class RemoveSharedExplorationIdsFromExploration < ActiveRecord::Migration[7.1]
  def change
    remove_column :explorations, :shared_exploration_ids, :text, array: true, default: []
  end
end
