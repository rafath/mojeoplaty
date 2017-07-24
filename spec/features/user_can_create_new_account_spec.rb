require 'rails_helper'

describe 'User as owner of company' do

  it 'can register from offer site', js: true do
    user = FactoryGirl.build(:user)
    visit '/'

    expect(page).to have_content 'Imię'
    expect(page).to have_content 'Nazwisko'
    expect(page).to have_content 'Nazwa firmy'
    expect(page).to have_content 'Adres email'

    within find('#account') do
      fill_in 'user_firstname', with: user.firstname
      fill_in 'user_lastname', with: user.lastname
      fill_in 'user_company_name', with: user.company_name
      fill_in 'user_nip', with: user.nip
      fill_in 'user_email', with: user.email
      fill_in 'user_phone', with: '523 34 44-44'
      fill_in 'user_password', with: '123456'
      fill_in 'user_password_confirmation', with: '123456'

      click_on 'user_submit_action'
    end

    wait_for_ajax

    saved_user = User.first

    # puts '-------'
    # puts ActionMailer::Base.deliveries.inspect

    expect(User.count).to eq 1
    expect(saved_user.email).to eq user.email
    expect(saved_user.phone).to eq '48523344444'

    expect(page).to have_content('Dziękujemy za Twoje zgłoszenie')
    within find('#account') do
      expect(page).not_to have_content 'Imię'
      expect(page).not_to have_content 'Nazwisko'
      expect(page).not_to have_content 'Adres email'
    end
  end

  it 'can login into admin' do
    visit account_path
    expect(page).to have_content 'zaloguj się'
    login_as
    expect(page).not_to have_content 'zaloguj'
    expect(page).to have_content 'Wyloguj się'
  end


  it 'as employee can sign in' do
    employee = create(:employee)
    visit account_path
    expect(page).to have_content 'zaloguj się'
    login_as(employee)
    expect(page).not_to have_content 'zaloguj się'
    expect(page).to have_content 'Wyloguj się'
  end

end
