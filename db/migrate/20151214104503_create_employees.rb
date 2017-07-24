class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.belongs_to :user
      t.string :firstname
      t.string :lastname
      t.timestamps null: false
    end
  end
end
