class Photo < ActiveRecord::Base
  mount_uploader :content, PhotoUploader

  serialize :exif

  before_save :set_metadata

  def album
    Albums::Inbox.new
  end

  def to_base64
    Base64.encode64(content.read) if content.present?
  end

  private

  def set_metadata
    metadata = PhotoMetadata.new(content, logger: Rails.logger)
    self.content_type = metadata.content_type
    self.filename = metadata.filename
    self.latitude = metadata.latitude
    self.longitude = metadata.longitude
    self.comment = metadata.comment
    self.taken_at = metadata.taken_at
    self.exif = metadata.exif_hash
  end
end
