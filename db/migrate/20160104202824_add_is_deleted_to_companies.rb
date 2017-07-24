class AddIsDeletedToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :is_deleted, :boolean, index: true, default: false
  end
end
