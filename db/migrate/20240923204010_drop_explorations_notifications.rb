class DropExplorationsNotifications < ActiveRecord::Migration[7.1]
  def change
    drop_table :explorations_notifications, if_exists: true
  end
end
