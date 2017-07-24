require 'rails_helper'

RSpec.describe Company, type: :model do

  let!(:user) { create(:user) }
  let!(:company) { create(:company, user: user, id: 1) }

  it 'can get zus_amount' do
    company1 = create(:company, user: user, id: 2)

    create(:zus_amount, user: user, company: company, period: '2012-12-01')
    create(:zus_amount, user: user, company: company1, period: '2013-12-01')
    create(:zus_amount, user: user, company: company, us: 30.90, period: (Time.now-2.months).strftime('%Y-%m-01'))

    companies = user.companies.includes(:before_current_zus_amount).order('id')
    expect(companies.count).to eq 2

    expect(companies.first.before_current_zus_amount).to be_present
    expect(companies.first.before_current_zus_amount.us).to eq 30.90

    expect(companies.last.current_zus_amount).to be_blank

    # puts current_zus.inspect
    # puts '-------'
    # puts company.last_zus_amount.inspect
    # puts company.last_zus_amount.us.to_f.inspect
  end

  it 'checks by_nip scope' do

    create(:company, user: user, nip: '834-293-20-00', id: 100)

    company = user.companies.by_nip('xxx')
    expect(company.count).to eq 0

    company = user.companies.by_nip('834-293-20-00')
    expect(company.count).to eq 1

    company = user.companies.by_nip('8342932000')
    expect(company.count).to eq 1
  end

  it 'returns proper phone format for sms' do
    company.update_attribute(:phone, '512 77 99 00')
    expect(company.phone).to eq '48512779900'

    company.update_attribute(:phone, '48 512 77 99 00')
    expect(company.phone).to eq '48512779900'

    company.update_attribute(:phone, '48512779900')
    expect(company.phone).to eq '48512779900'

    company.update_attribute(:phone, '+48 512 77 99 00')
    expect(company.phone).to eq '48512779900'

    company.update_attribute(:phone, '+48 512-77.99 00')
    expect(company.phone).to eq '48512779900'

    company.update_attribute(:phone, '48 512-77.99 00')
    expect(company.phone).to eq '48512779900'

  end
end
