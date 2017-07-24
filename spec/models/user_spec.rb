require 'rails_helper'

RSpec.describe User, type: :model do

  it 'can change user data' do
    user = create(:user, company_name: 'DOM S.A')

    user.attributes = {company_name: 'Shoople', firstname: 'Jacek'}
    user.save
    # user.reload
    expect(user.company_name).to eq 'Shoople'
    expect(user.firstname).to eq 'Jacek'

  end

  it 'can change password' do
    user =  create(:user, password: '123456', password_confirmation: '123456')

    user.change_password = true

    user.current_password = ''
    user.password = 'qwerty'
    user.password_confirmation = 'qwerty'

    expect(user.valid?).to be false
    expect(user.errors[:current_password]).to include 'to pole musi być wypełnione'


    user.current_password = '1234567'
    user.valid?

    expect(user.errors[:current_password]).not_to include 'to pole musi być wypełnione'
    expect(user.errors[:current_password]).to include 'nie zgadza się z bieżącym hasłem'


    user.current_password = '123456'
    user.valid?

    expect(user.valid?).to be true
    user.save

    expect(user.valid_password?('qwerty')).to be true
  end

end
