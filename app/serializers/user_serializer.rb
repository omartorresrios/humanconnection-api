class UserSerializer < ActiveModel::Serializer
  attributes :id, :fullname, :profile_picture, :bio, :city, :email

  def id
    object.id.to_s
  end
end
