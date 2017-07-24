require 'rails_helper'

describe 'User can send SMS' do

  let!(:user) { create :user }
  let!(:company) { create :company, user: user }
  let!(:zus_amount) { create :zus_amount, user: user, company: company, period: ZusAmount.current_period }

  it 'can send sms' do

  end

end