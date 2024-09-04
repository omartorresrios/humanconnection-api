class UserSerializer < ActiveModel::Serializer

  attributes :id, :authentication_token, :fullname, :picture, :bio, :city, :email

  def id
    object.id.to_s
  end

  def authentication_token
    JsonWebToken.encode({ user_id: object.id })
  end
end
