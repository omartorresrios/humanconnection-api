class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.integer :recipient_id
      t.integer :actor_id
      t.datetime :read_at
      t.integer :notifiable_id
      t.text :notifiable_type

      t.timestamps null: false
    end

    add_index :notifications, :recipient_id
    add_index :notifications, :actor_id
  end
end
