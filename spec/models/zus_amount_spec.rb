require 'rails_helper'

RSpec.describe ZusAmount, type: :model do

  # xit 'checks whether record exists and create proper one for given period' do
  #   user = create(:user)
  #   company1 = create(:company, user: user)
  #   company2 = create(:company, user: user)
  #   company3 = create(:company, user: user)
  #   company4 = create(:company)
  #
  # end

  it 'checks included concern' do
    user = create(:user)
    company1 = create(:company, user: user)
    company2 = create(:company, user: user)

    zus_amounts = user.companies.find(company1.id).zus_amounts.by_period('2015-12-01')
    expect(zus_amounts).to be_blank

    create(:zus_amount, user: user, company: company1, us: '23,40', uz: '123.45', fp: '210,05')

    zus_amounts = user.companies.find(company1.id).zus_amounts.by_period(ZusAmount.current_period)
    expect(zus_amounts).not_to be_blank
    expect(zus_amounts.us).to eq 23.4
    expect(zus_amounts.uz).to eq 123.45
    expect(zus_amounts.fp).to eq 210.05

    zs = user.companies.find(company2.id).zus_amounts.by_period(ZusAmount.current_period)
    expect(zs).to be_blank
  end

  xit 'gets payments from two months' do
    user = create(:user)
    company1 = create(:company, user: user)
    company2 = create(:company, user: user)
    create(:zus_amount, user: user, company: company1, period: '2015-11-01', us: '200,30')
    zus_amounts = ZusAmount.by_period('2015-11-01').includes(user.companies)

    expect(user.companies).to eq 2
    expect(zus_amounts).to be_present
    expect(zus_amounts.us).to eq 200.3

    # @default_zus_amounts = current_user.companies.zus_amounts.by_period(ZusAmount.two_months_ago)
  end

  it 'can assign period' do
    zus = ZusAmount.new
    zus.assign_period
    expect(zus.period.to_s).to eq ZusAmount.current_period
  end

  it 'can create short for account' do

    zus = create(:zus_amount)

    expect(zus.short_account('uz')).to eq '78..9520'
    expect(zus.short_account('us')).to eq '83..9510'
    expect(zus.short_account('fp')).to eq '73..9530'

  end
end
