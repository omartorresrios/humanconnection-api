class AddGoogleIdToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :google_id, :text
    add_index :users, :google_id, unique: true
  end
end
