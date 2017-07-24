class AddSentVatToTaxAmounts < ActiveRecord::Migration
  def change
    add_column :tax_amounts, :is_sent_vat, :boolean, default: false
    add_index :tax_amounts, :is_sent_vat
  end
end
