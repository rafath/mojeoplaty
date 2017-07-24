class HomeController < ApplicationController

  layout 'offer'

  def index
    @user = User.new
  end

  def create_user
    @user = User.new(user_params)
    UserMailer.welcome_user(@user).deliver_now if @user.save
    render layout: false
  end

  def privacy

    render layout: false
  end

  def terms

    render layout: false
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :firstname, :lastname, :company_name, :nip, :phone)
  end
end
