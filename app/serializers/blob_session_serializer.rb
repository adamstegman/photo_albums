class BlobSessionSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :access_key_id, :secret_access_key, :session_token
end
