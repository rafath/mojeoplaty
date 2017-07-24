require 'rails_helper'

describe 'User can manage taxes' do
  let!(:user) { create :user }
  let!(:company1) { create :company, user: user, name: 'Apple' }
  let!(:company2) { create :company, user: user, name: 'Ebay' }
  let!(:company3) { create :company, user: user, name: 'Google' }

  let!(:employee1) { create :employee, user: user}

  it 'can add proper values to fields', js: true do

    login_as(user)

    within find('.ace-nav') do
      click_on 'Opłaty US'
    end

    within('tr', text: 'Apple') do
      fill_in "vat_#{company1.id}", with: '135,44'
      fill_in "income_tax_#{company1.id}", with: '35,40'
      fill_in "pit_4_#{company1.id}", with: '200,05 zł'
      fill_in "pit_8_#{company1.id}", with: '135.40'
    end

    wait_for_ajax

    expect(company1.current_tax_amount.vat).to eq 135.44
    expect(company1.current_tax_amount.income_tax).to eq 35.4
    expect(company1.current_tax_amount.pit_4).to eq 200.05
    expect(company1.current_tax_amount.pit_8).to eq 135.40

    expect(company2.current_tax_amount).to be_blank


  end

end