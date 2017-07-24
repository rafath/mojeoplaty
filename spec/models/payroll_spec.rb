require 'rails_helper'

describe Payroll do

  let!(:user) { create(:user) }
  let!(:company) { create(:company, user: user) }
  let!(:employee) { create(:employee, user: user) }

  it 'can control user and employee association' do
    payroll = Payroll.new(
                         user: user,
                         company: company,
                         filename: '123.pdf'
    )
    expect(payroll.user_id).to eq user.id
    expect(payroll.employee_id).to be_zero
    expect(payroll.company_id).to eq company.id

    payroll = Payroll.create(
        user_id: employee.id,
        company: company,
        filename: '123.pdf'
    )

    #puts payroll.inspect
    expect(payroll.user_id).to eq user.id
    expect(payroll.employee_id).to eq employee.id
  end
end