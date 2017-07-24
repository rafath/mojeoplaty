class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  add_flash_types :danger, :success, :error

  add_breadcrumb 'Strona Główna', :account_path

  layout :layout_by_resource

  def after_sign_in_path_for(resource)
    # if resource.is_a? User
    session[:return_to] || account_home_path
    # else
    #   super
    # end
  end

  def authenticate_with_session(path=false)
    if current_user.nil?
      session[:return_to] = path.blank? ? request.fullpath : path
      authenticate_user!
    end
  end

  def restrict_access
    if current_user.is_employee?
      flash[:error] = 'Nie masz dostępu do tej strony'
      redirect_to account_home_path
    end
  end

  def current_accountant
    @account ||= current_user.is_employee? ? Employee.by_owner(current_user.owner).find(current_user.id) : current_user
  end

  def option_params
    params.require(:csv_settings).permit(:col_sep).to_h
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
  protected

  def layout_by_resource
    devise_controller? ? 'devise' : 'application'
  end

end
