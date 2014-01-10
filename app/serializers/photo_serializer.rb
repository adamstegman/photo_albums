class PhotoSerializer < ActiveModel::Serializer
  attributes :id, :filename, :content_type, :width, :height, :latitude, :longitude, :taken_at, :comment, :content
  has_one :album, embed: :id

  def content
    object.to_base64
  end
end
