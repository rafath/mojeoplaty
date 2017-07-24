class AddCityToTaxOffices < ActiveRecord::Migration
  def change
    add_column :tax_offices, :postcode, :string
    add_column :tax_offices, :city, :string
    add_index :tax_offices, [:city]
  end
end
