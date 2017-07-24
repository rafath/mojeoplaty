class CreateZusAmounts < ActiveRecord::Migration
  def change
    create_table :zus_amounts do |t|
      t.belongs_to :user
      t.belongs_to :employee
      t.belongs_to :company
      t.date :period
      t.string :payment_type, default: 'S', limit: 2
      t.decimal :us, precision: 10, scale: 2, default: 0.00
      t.decimal :uz, precision: 10, scale: 2, default: 0.00
      t.decimal :fp, precision: 10, scale: 2, default: 0.00
      t.decimal :ep, precision: 10, scale: 2, default: 0.00
      t.boolean :is_sent, default: false
      t.datetime :sent_at
      t.integer :viewed_counter, default: 0
      t.datetime :viewed_at
      t.timestamps null: false
    end
    add_index :zus_amounts, [:user_id, :employee_id]
    add_index :zus_amounts, [:company_id]
    add_index :zus_amounts, [:is_sent]
  end
end
