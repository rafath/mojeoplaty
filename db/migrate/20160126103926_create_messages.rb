class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.belongs_to :user
      t.belongs_to :company
      t.string :source, limit: 20 # zus || us || payrolls || invoices
      t.string :destination, limit: 20, default: 'email' # or sms
      t.string :recipients #email or phone no
      t.string :subject
      t.text :body
      t.datetime :created_at
    end
  end
end
