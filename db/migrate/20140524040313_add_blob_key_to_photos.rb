class AddBlobKeyToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :blob_key, :string
  end
end
