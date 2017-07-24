class AddMessageToAmounts < ActiveRecord::Migration
  def change
    add_column :zus_amounts, :message, :string, limit: 1000
    add_column :tax_amounts, :message, :string, limit: 1000
  end
end
