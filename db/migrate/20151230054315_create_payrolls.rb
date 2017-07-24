class CreatePayrolls < ActiveRecord::Migration
  def change
    create_table :payrolls do |t|
      t.belongs_to :user
      t.belongs_to :employee, default: 0
      t.belongs_to :company
      t.date :period
      t.string :filename
      t.boolean :is_sent, default: false
      t.datetime :sent_at
      t.integer :viewed_counter, default: 0
      t.datetime :viewed_at
      t.timestamps null: false
    end
    add_index :payrolls, [:user_id, :employee_id]
    add_index :payrolls, [:company_id]
    add_index :payrolls, [:is_sent]
  end
end
