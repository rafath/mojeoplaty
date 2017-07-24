class AddSmsToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :send_sms, :boolean, default: false
  end
end
