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
    if content.present?
      self.filename = content.filename
      self.content_type = content.file.content_type
      if content_type == 'image/jpeg'
        exif = EXIFR::JPEG.new(StringIO.new(content.read))
        self.exif = exif.exif.try(:to_hash)
        self.comment = exif.comment
        self.taken_at = exif.date_time_original.try(:utc)
        if exif.gps
          self.latitude = exif.gps[:latitude]
          self.longitude = exif.gps[:longitude]
        end
      end
      self.taken_at = Time.zone.now unless taken_at
    end
  end
end
