class Exploration < ApplicationRecord
  belongs_to :user
  has_many :notifications
  
  after_create :look_for_related_explorations
  before_destroy :remove_reference_in_other_explorations, :remove_notifications
  scope :worldwide_except_from, ->(user) { where.not(user: user) }
  
  def look_for_related_explorations
    SimilarExplorationsJob.perform_async(self.user_id, self.id, self.text)
  end

  def remove_reference_in_other_explorations
    RemoveExplorationReferenceInOthersJob.perform_async(self.id, self.user_id)
  end

  def remove_notifications
    Notification.where(exploration_id: self.id).destroy_all
  end
end
