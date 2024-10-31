class ExplorationSerializer < ActiveModel::Serializer
  attributes :id, :text, :sources
  belongs_to :user, serializer: UserSerializer
  has_many :similar_explorations

  def id
    object.id.to_s
  end

  def similar_explorations
    Exploration.where(id: object.similar_exploration_ids)
  end
end