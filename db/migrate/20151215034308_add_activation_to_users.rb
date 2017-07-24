class AddActivationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_active, :boolean
    add_index :users, :is_active
  end
end
