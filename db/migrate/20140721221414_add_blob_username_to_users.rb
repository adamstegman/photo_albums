class AddBlobUsernameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :blob_username, :string
  end
end
