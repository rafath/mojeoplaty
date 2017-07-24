class AccountController < ApplicationController

  before_filter :authenticate_with_session, except: [:sign_in]

  def sign_in
    render layout: 'devise'
  end

  def index

  end

  def edit
    add_breadcrumb 'Edycja danych'
  end

  def update
    # current_user.attributes = user_params
    # current_user.save
    current_user.update_without_password(user_params)
  end

  def change_password
    current_user.change_password = true
    current_user.attributes = password_params
    sign_in(current_user, bypass: true) if current_user.save
  end

  private

  def user_params
    params.require(:user).permit(:firstname, :lastname, :email, :phone, :company_name, :nip, :address_1, :address_2)
  end

  def password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end

end
