class PhotoSerializer < ActiveModel::Serializer
  self.root = false

  attributes(
    :id,
    :filename,
    :content_type,
    :width,
    :height,
    :latitude,
    :longitude,
    :taken_at,
    :comment,
    :blob_bucket,
    :blob_key
  )
  has_one :album, embed: :id
  has_one :blob_session, embed: :id

  def blob_session
    BlobSession.new(object.blob_bucket, object.user)
  end
end
