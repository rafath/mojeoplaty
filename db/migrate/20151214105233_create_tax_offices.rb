class CreateTaxOffices < ActiveRecord::Migration
  def change
    create_table :tax_offices do |t|
      t.string :name
      t.string :address
      t.string :bank_name
      t.string :vat_account
      t.string :cit_account
      t.string :pit_account
      t.string :pcc_account
      t.timestamps null: false
    end
  end
end
