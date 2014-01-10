class AddExifToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :exif, :text
    add_column :photos, :taken_at, :datetime
    add_column :photos, :latitude, :float
    add_column :photos, :longitude, :float
    add_column :photos, :comment, :text
  end
end
