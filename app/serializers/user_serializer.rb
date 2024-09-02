class UserSerializer < ActiveModel::Serializer
  attributes :id, :fullname, :picture, :bio, :city, :email

  def id
    object.id.to_s
  end
end
