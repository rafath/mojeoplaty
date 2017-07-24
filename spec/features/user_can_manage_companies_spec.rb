require 'rails_helper'

describe 'User can manage companies' do

  let!(:tax_office) { create(:tax_office) }
  let!(:user) { create(:user) }

  before(:each) do
    login_as(user)
  end

  context 'Add company' do
    it 'creates company', js: true do
      visit '/companies/new'
      expect(page).to have_content 'Dodaj nową firmę'
      within find('#new_company') do
        fill_in_selectized 'company_tax_office_id', 'august', tax_office.id
        fill_in 'company_name', with: 'ARM Sp. z o.o.'
        fill_in 'company_phone', with: '512 779 001'
        fill_in 'company_email', with: 'arm@zaraz.pl'
        fill_in 'company_cc_emails', with: 'ksiegowa@zaraz.pl, ja@zaraz.pl'
        fill_in 'company_nip', with: '846-166 18.44'
        select 'VAT 7K', from: 'company_vat_type'
        select 'PIT 5L', from: 'company_tax_type'
        find(:css, '#company_has_employees').set(true)
      end
      click_on 'company_submit_action'
      wait_for_ajax
      company = Company.all.first
      expect(Company.count).to eq 1
      expect(company.user_id).to eq user.id
      expect(company.name).to eq 'ARM Sp. z o.o.'
      expect(company.nip).to eq '8461661844'
      expect(company.phone).to eq '48512779001'
      expect(company.tax_office_id).to eq tax_office.id
      expect(page).to have_content('Firma została dodana')
    end
  end

  it 'can edit company', js: true do
    company = create(:company, user: user, nip: '100-200-30-40')
    visit '/companies'
    within find('table.table') do
      expect(page).to have_content company.name
      expect(page).to have_content company.tax_office.name
      expect(page).to have_content company.phone
      expect(page).to have_content '100-200-30-40'
      within('tr', text: company.name) do
        find('a.btn.btn-success').click
      end
    end

    wait_for_ajax

    within('h2') do
      expect(page).to have_content company.name
    end

    expect(company.tax_office_id).not_to eq tax_office.id

    fill_in_selectized 'company_tax_office_id', 'august', tax_office.id
    fill_in 'company_name', with: 'Nowa nazwa firmy'
    fill_in 'company_phone', with: '885 160 170'
    fill_in 'company_email', with: 'ceo@company.pl'
    find(:css, '#company_has_employees').set(false)
    click_on 'company_submit_action'

    wait_for_ajax
    expect(page).to have_content 'Dane zostały zmienione'
    expect(page).to have_content 'Lista firm'

    within('table.table tr', text: 'Nowa nazwa firmy') do
      expect(page).to have_content '100-200-30-40'
      expect(page).to have_content '48885160170'
      expect(page).to have_content 'ceo@company.pl'
      expect(page).to have_content tax_office.name
    end
  end

  it 'can delete company', js: true do
    company = create(:company, user: user, name: 'UOP')
    company1 = create(:company, user: user, name: 'Shoople')

    visit '/companies'

    expect(Company.count).to eq 2

    within find('table.table') do
      expect(page).to have_content company.name
      expect(page).to have_content company1.name
    end

    within find('table.table tr', text: company1.name) do
      find('a.btn.btn-danger').click
    end

    wait_for_ajax

    expect(Company.count).to eq 1
    expect(page).to have_content company.name
    expect(page).not_to have_content company1.name

  end

  it 'can import companies by uploading csv file'

  it 'can export companies by downloading csv'

end

