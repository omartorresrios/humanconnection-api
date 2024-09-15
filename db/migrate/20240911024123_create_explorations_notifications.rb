class CreateExplorationsNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :explorations_notifications do |t|
      t.bigint :exploration_id, null: false
      t.bigint :notification_id, null: false

      t.index [:exploration_id, :notification_id], name: "index_expl_notifications_on_expl_id_and_notification_id"
    end
  end
end
