require 'rails_helper'

describe 'User can manage employees and companies' do
  let!(:user) { create :user }
  let!(:company1) { create :company, user: user }
  let!(:company2) { create :company, user: user }
  let!(:company3) { create :company, user: user }
  let!(:company4) { create :company, user: user }

  let!(:employee1) { create :employee, user: user}
  let!(:employee2) { create :employee, user: user}
  let!(:employee3) { create :employee, user: user}
  let!(:employee4) { create :employee, user: user}

  before(:each) do
    login_as(user)
  end

  it 'checs hbtm associations' do

    expect(user.companies.count).to eq 4
    expect(employee1.companies.count).to eq 0
    expect(company1.employees.count).to eq 0

    Employee.by_owner(user.id).find(employee1.id).companies << [company1, company2]

    expect(user.companies.count).to eq 4
    expect(employee1.companies.count).to eq 2
    expect(company1.employees.count).to eq 1
    expect(company2.employees.count).to eq 1

  end

  it 'can add or remove employee to/from company', js: true do

    within find('.ace-nav') do
      find('a', text: 'Przypisz firmy').trigger('click')
    end

    within find('table.table') do
      expect(page).to have_content company1.name
      expect(page).to have_content company1.formatted_nip
      expect(page).to have_content employee2.lastname

      find(:css, "#com_emp_#{company1.id}_#{employee4.id}").trigger('click')
      find(:css, "#com_emp_#{company2.id}_#{employee3.id}").trigger('click')
      find(:css, "#com_emp_#{company3.id}_#{employee2.id}").trigger('click')
      find(:css, "#com_emp_#{company3.id}_#{employee1.id}").trigger('click')

      wait_for_ajax

      expect(company1.employees.count).to eq 1
      expect(company1.employees).to include employee4
      expect(employee4.companies).to include company1
      expect(company3.employees.count).to eq 2
      expect(company3.employees).to include employee2
      expect(company3.employees).to include employee1

      expect(company4.employees.count).to eq 0

      find(:css, "#com_emp_#{company1.id}_#{employee3.id}").trigger('click')
      find(:css, "#com_emp_#{company3.id}_#{employee2.id}").trigger('click')

      wait_for_ajax

      expect(company1.employees.count).to eq 2
      expect(company1.employees).to include employee4
      expect(company1.employees).to include employee3
      expect(company3.employees.count).to eq 1
      expect(company3.employees).not_to include employee2
      expect(company3.employees).to include employee1

    end
  end
end
