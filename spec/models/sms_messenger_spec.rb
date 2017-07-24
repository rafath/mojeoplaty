require 'rails_helper'


describe SmsMessenger do

  let!(:user) { create(:user) }
  let!(:company) { create(:company, user: user, phone: '512779001') }
  let!(:zus_amount) { create(:zus_amount, user: user, company: company) }
  let!(:tax_amount) { create(:tax_amount, user: user, company: company) }

  it 'can create zus sms message' do
    sms = SmsMessenger.new(zus_amount, true)
    expect(sms.send_zus.length).to be <= 160
  end

  it 'can create tax sms message' do
    sms = SmsMessenger.new(tax_amount, true)
    # puts sms.send_tax
    expect(sms.send_tax.length).to be <= 160
  end

  it 'can create tax sms message for cit' do
    company.update_attribute(:tax_type, 'cit-8')
    sms = SmsMessenger.new(tax_amount, true)
    # puts sms.send_tax
    expect(sms.send_tax.length).to be <= 160
    expect(sms.send_tax.include?('CIT-8')).to eq true
  end

  it 'can create vat sms message' do
    sms = SmsMessenger.new(tax_amount, true)
    puts sms.send_vat
    expect(sms.send_vat.length).to be <= 160
  end

  it 'can create test sms message' do
    sms = SmsMessenger.new(zus_amount, true)
    expect(sms.send_test.status).to eq :ok
  end
end