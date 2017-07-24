require 'rails_helper'

describe 'User can manage zus' do

  let!(:user) { create :user }
  let!(:company1) { create :company, user: user, name: 'Apple' }
  let!(:company2) { create :company, user: user, name: 'Ebay' }
  let!(:company3) { create :company, user: user, name: 'Google' }

  let!(:employee1) { create :employee, user: user}

  let!(:zus_amount1) { create :zus_amount, user: user, company: company1, period: ZusAmount.before_current_period}
  let!(:zus_amount2) { create :zus_amount, user: user, company: company2, period: ZusAmount.before_current_period}
  let!(:zus_amount3) { create :zus_amount, user: user, company: company3, period: ZusAmount.before_current_period}

  #Employee.by_owner(user.id).find(employee1.id).companies << [company1, company2]

  it 'can copy zus amounts as owner', js: true do

    login_as(user)

    within find('.ace-nav') do
      click_on 'Opłaty ZUS'
      # find('a', text: 'Dodaj nowe opłaty').trigger('click')
    end

    within find('h2') do
      expect(page).to have_content 'Dodaj nowe opłaty'
    end

    expect(page).to have_css('table.table tbody tr', count: 3)
    expect(ZusAmount.where(period: ZusAmount.before_current_period, user_id: user.id).count).to eq 3
    expect(ZusAmount.where(period: ZusAmount.current_period, user_id: user.id).count).to eq 0

    click_on 'Kopiuj płatności do bieżącego okresu'

    wait_for_ajax

    expect(ZusAmount.where(period: ZusAmount.before_current_period, user_id: user.id).count).to eq 3
    expect(ZusAmount.where(period: ZusAmount.current_period, user_id: user.id).count).to eq 3

    within find('h2') do
      expect(page).to have_content 'Opłaty ZUS za okres bieżący'
    end
    expect(page).to have_content 'Ilość skopiowanych rekordów: 3'
  end

  it 'can copy own zus amounts as employee', js: true do

    expect(user.employees.count).to eq 1

    Employee.by_owner(user.id).find(employee1.id).companies << [company1, company2]
    login_as(employee1)
    within find('.ace-nav') do
      click_on 'Opłaty ZUS'
    end

    within find('h2') do
      expect(page).to have_content 'Dodaj nowe opłaty'
    end

    expect(page).to have_css('table.table tbody tr', count: 2)
    expect(employee1.companies.count).to eq 2

    click_on 'Kopiuj płatności do bieżącego okresu'

    wait_for_ajax

    within find('h2') do
      expect(page).to have_content 'Opłaty ZUS za okres bieżący'
    end
    expect(page).to have_content 'Ilość skopiowanych rekordów: 2'

    zus_amounts = ZusAmount.where(period: ZusAmount.current_period, user_id: user.id)
    expect(zus_amounts.count).to eq 2
    expect(zus_amounts.first.user.id).to eq user.id
    expect(zus_amounts.first.employee.id).to eq employee1.id
  end

  it 'can add proper values to fields', js: true do
    login_as(user)
    within find('.ace-nav') do
      click_on 'Opłaty ZUS'
    end

    within('tr', text: 'Apple') do
      fill_in "us_#{company1.id}", with: '35,40'
      fill_in "uz_#{company1.id}", with: '200,05 zł'
      fill_in "fp_#{company1.id}", with: '135.40'
    end

    wait_for_ajax
    expect(company1.current_zus_amount.us).to eq 35.4
    expect(company1.current_zus_amount.uz).to eq 200.05
    expect(company1.current_zus_amount.fp).to eq 135.40
  end

end