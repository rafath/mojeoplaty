class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :firstname
      t.string :lastname
      t.string :company_name
      t.string :nip
      t.string :address_1 #street + number
      t.string :address_2 #city code
      t.string :phone, limit: 128
      t.integer :company_counter, default: 0
      t.boolean :is_paid, default: false
      t.timestamps null: false
    end
    add_index :users, :email, unique: true
  end
end
