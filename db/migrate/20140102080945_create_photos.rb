class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :filename
      t.string :content_type
      t.integer :width
      t.integer :height
      t.string :content

      t.timestamps
    end
  end
end
