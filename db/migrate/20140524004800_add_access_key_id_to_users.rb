class AddAccessKeyIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :access_key_id, :string
  end
end
