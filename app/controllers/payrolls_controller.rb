class PayrollsController < ApplicationController

  before_filter :authenticate_with_session

  def index
    add_breadcrumb 'Lista Płac'
    @companies = current_accountant.companies.with_employees.includes(:payroll)
  end

  def upload
    company = current_accountant.companies.find(params[:id])
    @uploader = PayrollUploader.new(current_accountant, company, params[:payroll_file])
    if @uploader.valid?
      @uploader.upload_file
      @payroll = Payroll.create(
                 user_id: current_accountant.id,
                 company: company,
                 filename: @uploader.filename
      )
    end
  end

  def download
    payroll = current_accountant.companies.find(params[:id]).payrolls.find(params[:pid])
    send_file payroll.file_path, filename: payroll.download_filename
  end

end
