class UserSerializer < ActiveModel::Serializer
  self.root = false

  attributes :user_email, :user_token

  def user_email
    object.email
  end

  def user_token
    object.token
  end
end
