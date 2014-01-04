class PhotoSerializer < ActiveModel::Serializer
  attributes :id, :filename, :content_type, :width, :height, :content

  def content
    object.to_base64
  end
end
