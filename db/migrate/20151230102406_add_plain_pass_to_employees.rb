class AddPlainPassToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :plain_pass, :string, limit: 128
  end
end
