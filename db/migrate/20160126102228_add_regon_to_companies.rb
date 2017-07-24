class AddRegonToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :regon, :string
  end
end
