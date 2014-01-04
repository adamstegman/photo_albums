class Photo < ActiveRecord::Base
  mount_uploader :content, PhotoUploader

  before_save :set_metadata

  def to_base64
    Base64.encode64(content.read) if content.present?
  end

  private

  def set_metadata
    if content.present?
      self.filename = content.filename
      self.content_type = content.file.content_type
    end
  end
end
