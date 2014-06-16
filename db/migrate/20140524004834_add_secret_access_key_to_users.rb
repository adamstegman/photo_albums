class AddSecretAccessKeyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :secret_access_key, :string
  end
end
