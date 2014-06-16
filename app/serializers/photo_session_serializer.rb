class PhotoSessionSerializer < ActiveModel::Serializer
  self.root = false

  has_one  :photo
  has_many :blob_sessions

  def photo
    object
  end

  def blob_sessions
    [BlobSession.new(object.blob_bucket, object.user)]
  end
end
