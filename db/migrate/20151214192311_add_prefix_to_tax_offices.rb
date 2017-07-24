class AddPrefixToTaxOffices < ActiveRecord::Migration
  def change
    add_column :tax_offices, :prefix, :string, limit: 99
    add_index :tax_offices, :prefix
  end
end
