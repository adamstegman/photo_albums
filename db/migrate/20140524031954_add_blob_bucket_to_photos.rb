class AddBlobBucketToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :blob_bucket, :string
  end
end
