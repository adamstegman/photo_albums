class UserSerializer < ActiveModel::Serializer
  self.root = false

  attributes :auth_email, :auth_token

  def auth_email
    object.email
  end

  def auth_token
    object.token
  end
end
