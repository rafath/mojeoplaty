class CreateEmailMessages < ActiveRecord::Migration
  def change
    create_table :email_messages do |t|
      t.belongs_to :user
      t.belongs_to :company
      t.string :recipient
      t.string :subject
      t.text :body
      t.timestamps null: false
    end
    add_index :email_messages, [:user_id]
    add_index :email_messages, [:company_id]
  end
end
