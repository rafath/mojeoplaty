class AddOwnerToUsers < ActiveRecord::Migration
  def change
    add_column :users, :owner, :integer, default: 0, index: true
    User.update_all(owner: 0)
  end
end
