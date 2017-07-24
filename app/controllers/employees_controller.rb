class EmployeesController < ApplicationController

  before_filter :authenticate_with_session, :restrict_access
  before_filter :load_employee, except: :create


  def index
    add_breadcrumb 'Lista praocowników'
    @employees = current_user.employees
  end

  def new
    render layout: false
  end

  def edit
    render layout: false
  end

  def create
    @employee = Employee.new(employee_params)
    @employee.owner = current_user.id
    @employee.save
    render layout: false
  end

  def update
    @employee.update_attributes(employee_params)
    @employee.save
  end

  def destroy
    @employee.destroy
    render layout: false
  end

  def companies
    add_breadcrumb 'Lista praocowników', employees_path
    add_breadcrumb 'Przypisz firmy'

    @companies = current_user.companies.includes(:employees).page(params[:page])
    @employees = current_user.employees
  end

  def assign
    employee = Employee.by_owner(current_user.id).find(params[:e].to_i)
    company = current_user.companies.find(params[:c].to_i)
    params[:f].to_i == 1 ? employee.companies << company : employee.companies.delete(company)
    render text: 'ok'
  end

  private

  def load_employee
    @employee = params[:id].present? ? Employee.where(id: params[:id], owner: current_user.id).first : Employee.new
  end

  def employee_params
    params.require(:employee).permit(:firstname, :lastname, :email, :plain_pass)
  end

end
