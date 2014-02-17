class PhotoMetadata
  attr_accessor :content

  def initialize(content, options = {})
    @content = content
    @logger = options[:logger]
  end

  def content_type
    content && content.file && content.file.content_type
  end

  def filename
    content && content.filename
  end

  def latitude
    exif && exif.gps && exif.gps[:latitude]
  end

  def longitude
    exif && exif.gps && exif.gps[:longitude]
  end

  def comment
    exif && exif.comment
  end

  def taken_at
    if exif
      if exif.gps_time_stamp && exif.gps_date_stamp
        hour, minute, second = exif.gps_time_stamp.map { |num| num.to_i }
        year, month, day = exif.gps_date_stamp.split(':').map(&:to_i)
        Time.new(year, month, day, hour, minute, second, 0)
      elsif exif.date_time_original
        time = localized_date_time_original_in_utc || default_localized_date_time_original_in_utc
      end
    end
  end

  def exif_hash
    exif && exif.exif.to_hash
  end

  private

  def exif
    if content && (content_string = content.read)
      @exif ||= EXIFR::JPEG.new(StringIO.new(content_string))
    end
  rescue ArgumentError, EXIFR::MalformedJPEG
  end

  def logger
    @logger ||= Logger.new(STDERR)
  end

  def localized_date_time_original_in_utc
    if exif.gps
      utc_offset = UtcOffset.utc_offset_hours(exif.date_time_original, exif.gps)
      exif.date_time_original.to_datetime.change(offset: sprintf("%+03d00", utc_offset)).utc
    end
  rescue UtcOffset::UtcOffsetNotFoundError => e
    logger.info { "#{self.class.name}#taken_at: #{exif.date_time_original.inspect} at #{exif.gps.inspect} UTC offset not found" }
    nil
  end

  def default_localized_date_time_original_in_utc
    time = exif.date_time_original.to_datetime.change(offset: sprintf("%+03d00", UtcOffset::DEFAULT_UTC_OFFSET))
    time = time.change(offset: sprintf("%+03d00", UtcOffset::DEFAULT_UTC_OFFSET + 1)) if time.to_time.dst?
    time.utc
  end
end