class CreateExplorations < ActiveRecord::Migration[7.1]
  def change
    create_table :explorations do |t|
      t.text :text
      t.text :sources, array: true, default: []
      t.text :shared_exploration_ids, array: true, default: []
      t.timestamps
    end
  end
end
