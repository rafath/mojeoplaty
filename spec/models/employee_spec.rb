require 'rails_helper'

RSpec.describe Employee, type: :model do

  it 'can see only own company' do
    user = create(:user)
    company1 = create(:company, user: user)
    company2 = create(:company, user: user)
    company3 = create(:company, user: user)
    company4 = create(:company)

    employee1 = create(:employee, user: user)
    employee2 = create(:employee, user: user)
    employee3 = create(:employee)

    expect(Company.count).to eq 4
    expect(user.companies.count).to eq 3
    expect(Employee.count).to eq 3
    expect(user.employees.count).to eq 2

    # ---- adding employee to company
    company1.employees << employee1
    company2.employees << employee1

    expect(company1.employees.count).to eq 1
    expect(company2.employees.count).to eq 1
    expect(employee1.companies.count).to eq 2

    company2.employees << employee2
    expect(company2.employees.count).to eq 2
    expect(company3.employees.count).to eq 0

    # puts company2.employee_ids.inspect
    # puts company1.employees.exists?(employee1.id)
    # puts company1.employees.exists?(employee2.id)

    company1.employees.delete(employee1)
    expect(company1.employees.count).to eq 0

    company2.employees.clear
    expect(company2.employees.count).to eq 0

    # expect(employee2.companies.count).to eq 1

  end
end
