class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.belongs_to :user
      t.belongs_to :tax_office
      t.string :name
      t.string :email
      t.string :cc_emails
      t.string :nip
      t.string :phone
      t.string :token
      t.string :vat_type, limit: 10 # vat | vat7k
      t.string :tax_type, limit: 10 # cit-8 | pit5 | pit-5l | pit-28
      t.boolean :has_employees, default: false
      t.timestamps null: false
    end

    add_index :companies, [:user_id, :nip]
    add_index :companies, [:user_id]
    add_index :companies, [:token], unique: true
  end
end
