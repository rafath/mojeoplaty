class CreateTaxAmounts < ActiveRecord::Migration
  def change
    create_table :tax_amounts do |t|
      t.belongs_to :user
      t.belongs_to :employee
      t.belongs_to :company
      t.date :period
      t.decimal :vat, precision: 10, scale: 2, default: 0.00
      t.decimal :income_tax, precision: 10, scale: 2, default: 0.00
      t.decimal :pit_4, precision: 10, scale: 2, default: 0.00
      t.decimal :pit_8, precision: 10, scale: 2, default: 0.00
      t.boolean :is_sent, default: false
      t.datetime :sent_at
      t.integer :viewed_counter, default: 0
      t.datetime :viewed_at
      t.timestamps null: false
    end
    add_index :tax_amounts, [:user_id, :employee_id]
    add_index :tax_amounts, [:company_id]
    add_index :tax_amounts, [:is_sent]
  end
end
