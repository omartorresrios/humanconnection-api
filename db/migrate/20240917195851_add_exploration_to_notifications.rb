class AddExplorationToNotifications < ActiveRecord::Migration[7.1]
  def change
    add_reference :notifications, :exploration, foreign_key: true
  end
end
