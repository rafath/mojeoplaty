class AddPlainPassToUsers < ActiveRecord::Migration
  def change
    add_column :users, :plain_pass, :string
  end
end
