class Notification < ApplicationRecord
  belongs_to :recipient, class_name: "User"
  belongs_to :actor, class_name: "User"
  belongs_to :notifiable, polymorphic: true
  has_and_belongs_to_many :explorations

  scope :recent, -> { order(created_at: :desc) }
  scope :unread, -> { where(read_at: nil) }
end