require 'rails_helper'

describe 'User can manage employees' do

  let!(:user) { create(:user) }

  before(:each) do
    login_as(user)
  end

  it 'creates employee', js: true do
    within find('.ace-nav') do
      click_on 'Pracownicy'
    end
    within find('table.form') do
      fill_in 'employee_firstname', with: 'Jarek'
      fill_in 'employee_lastname', with: 'Kaczyński'
      fill_in 'employee_email', with: 'jarek@wp.pl'
      fill_in 'employee_plain_pass', with: '123456'
      click_on 'Dodaj'
    end

    wait_for_ajax

    expect(Employee.count).to eq 1
    expect(Employee.first.firstname).to eq 'Jarek'
    expect(page).to have_content 'Pracownik został dodany'
    within find('table#employees') do
      expect(page).to have_content 'Jarek'
      expect(page).to have_content 'Kaczyński'
      expect(page).to have_content 'jarek@wp.pl'
      expect(page).to have_content '123456'
    end
  end

  it 'can edit employee', js: true do
    employee = create(:employee, owner: user.id)
    within find('.ace-nav') do
      click_on 'Pracownicy'
    end

    within find('table#employees tr', text: employee.email) do
      find('a.btn.btn-success').click
    end

    wait_for_ajax

    expect(Employee.first.firstname).to eq employee.firstname
    expect(Employee.first.email).to eq employee.email

    within find('table.form') do
      fill_in 'employee_firstname', with: 'John'
      fill_in 'employee_lastname', with: 'Travolta'
      fill_in 'employee_email', with: 'travolta@wp.pl'
      fill_in 'employee_plain_pass', with: '123456'
      click_on 'Zapisz'
    end

    wait_for_ajax

    within find('table#employees') do
      expect(page).to have_content 'John'
      expect(page).to have_content 'Travolta'
      expect(page).to have_content 'travolta@wp.pl'
      expect(page).to have_content '123456'
    end
  end

  it 'can delete employee', js: true do
    employee1 = create(:employee, owner: user.id)
    expect(Employee.count).to eq 1

    within find('.ace-nav') do
      click_on 'Pracownicy'
    end


    within find('table#employees') do
      expect(page).to have_content employee1.firstname
      expect(page).to have_content employee1.lastname
      find('a.btn.btn-danger').click
      wait_for_ajax
      expect(page).not_to have_content employee1.firstname
      expect(page).not_to have_content employee1.lastname
    end

    expect(Employee.count).to eq 0
  end

  it 'cant delete employee from another user', js: true do
    employee1 = create(:employee, owner: user.id)
    employee2 = create(:employee)

    within find('.ace-nav') do
      click_on 'Pracownicy'
    end

    expect(Employee.count).to eq 2

    within find('table#employees') do
      expect(page).to have_content employee1.email
      expect(page).not_to have_content employee2.email
    end

  end

end