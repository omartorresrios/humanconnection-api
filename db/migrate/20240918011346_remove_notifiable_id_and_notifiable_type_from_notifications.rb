class RemoveNotifiableIdAndNotifiableTypeFromNotifications < ActiveRecord::Migration[7.1]
  def change
    remove_column :notifications, :notifiable_id, :integer
    remove_column :notifications, :notifiable_type, :text
  end
end
