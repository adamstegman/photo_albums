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
        utc_offset = UtcOffset::DEFAULT_UTC_OFFSET
        utc_offset += 1 if exif.date_time_original.dst?
        if exif.gps
          begin
            utc_offset = UtcOffset.utc_offset_hours(exif.date_time_original, exif.gps)
          rescue UtcOffset::UtcOffsetNotFoundError => e
            logger.info { "#{self.class.name}#taken_at: #{exif.date_time_original.inspect} at #{exif.gps.inspect} UTC offset not found" }
          end
        end
        exif.date_time_original.to_datetime.change(offset: sprintf("%+03d00", utc_offset)).utc
      end
    end
  end

  def exif_hash
    exif && exif.exif.to_hash
  end

  def exif
    if content && (content_string = content.read)
      @exif ||= EXIFR::JPEG.new(StringIO.new(content_string))
    end
  rescue ArgumentError, EXIFR::MalformedJPEG
  end

  def logger
    @logger ||= Logger.new(STDERR)
  end
end
