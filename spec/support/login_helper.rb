module LoginHelper

  def login_as(user = FactoryGirl.create(:user))
    login_with(user.email, user.password)
  end

  def login_with(email, password)
    visit account_path
    fill_in 'user_email', with: email
    fill_in 'user_password', with: password
    click_on 'Zaloguj się'
  end

  def login_as_employee(email, password)
    visit '/employees/sign_in'
    fill_in 'employee_email', with: email
    fill_in 'employee_password', with: password
    click_on 'Zaloguj się'
  end



  def log_out
    Capybara.reset_sessions!
    visit destroy_user_session_url
  end
end

