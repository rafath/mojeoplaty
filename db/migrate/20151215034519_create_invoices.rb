class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.belongs_to :user
      t.integer :last_number, default: 0
      t.string :invoice_number
      t.string :title   #invoice title
      t.date :create_date
      t.date :trade_date # data sprzedaży (date)
      t.date :payment_date
      t.string :item_name
      t.decimal :price, precision: 10, scale: 2, default: 0.00
      t.decimal :vat, precision: 10, scale: 2, default: 1.23
      t.boolean :gross_price, default: true
      t.boolean :paid, default: false
      t.boolean :proforma, default: false
      t.string :payment_type, default: 'przelew'
      t.timestamps null: false
    end
    add_index :invoices, [:user_id]
  end
end
