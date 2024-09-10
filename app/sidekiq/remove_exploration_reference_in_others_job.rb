class RemoveExplorationReferenceInOthersJob
  include Sidekiq::Job

  def perform(explorationId, currentUserId)
    currentUser = User.find(currentUserId)
    Exploration.worldwide_except_from(currentUser).each { |exploration|
      if exploration.similar_exploration_ids.include?(explorationId.to_s)
        exploration.similar_exploration_ids.delete(explorationId.to_s)
        exploration.save
      end
    }
  end
end
  