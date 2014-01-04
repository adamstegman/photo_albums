class PhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MimeTypes
  include CarrierWave::RMagick

  process :set_content_type
  process :set_dimensions

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  def store_dir
    nil
  end

  def set_dimensions
    manipulate! do |img|
      model.width = img.columns
      model.height = img.rows
      img
    end
  end
end
