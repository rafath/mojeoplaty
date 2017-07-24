class CreateCompaniesEmployees < ActiveRecord::Migration
  def change
    create_table :companies_employees, id: false do |t|
      t.references :company
      t.references :employee
    end
    add_index :companies_employees, [:employee_id, :company_id]
    add_index :companies_employees, [:employee_id]
  end
end
