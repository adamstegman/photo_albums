class PhotosSessionsSerializer < ActiveModel::Serializer
  self.root = false

  has_many :photos
  has_many :blob_sessions

  def photos
    object
  end

  def blob_sessions
    object.group_by(&:blob_bucket).map { |bucket, photos| BlobSession.new(bucket, photos.first.user) }
  end
end
