class ExplorationSerializer < ActiveModel::Serializer
  attributes :id, :text, :sources, :shared_explorations
  belongs_to :user, serializer: UserSerializer

  def id
    object.id.to_s
  end

  def shared_explorations
    sharedExplorations = Exploration.where(id: object.shared_exploration_ids)
    sharedExplorations.map do |exploration|
      ExplorationSerializer.new(exploration)
    end
  end
end
