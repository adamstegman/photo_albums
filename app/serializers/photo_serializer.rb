class PhotoSerializer < ActiveModel::Serializer
  attributes :id, :filename, :contentType, :width, :height, :content

  def content
    object.to_base64
  end

  def contentType
    object.content_type
  end
end
