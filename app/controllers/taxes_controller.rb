class TaxesController < ApplicationController
  before_filter :authenticate_with_session

  def index
    @company_payments = current_accountant.companies.includes(:current_tax_amount)
    respond_to do |format|
      format.html do
        add_breadcrumb 'Opłaty US'
      end
      format.csv do
        send_data build_csv, filename: 'podatki.csv'
      end
    end
  end

  def save
    company = current_accountant.companies.find(params[:company])
    if company.current_tax_amount.present?
      company.current_tax_amount.attributes = {params[:type].to_sym => params[:value]}
    else
      company.create_current_tax_amount(params[:type].to_sym => params[:value], user: current_accountant)
    end
    company.current_tax_amount.save
    render text: 'ok'
  end

  def upload
    @uploader = TaxUploader.new(current_accountant, params[:csv], option_params)
    if @uploader.upload_file('taxes') === true
      flash[:success] = "Ilość poprawnie wczytanych rekordów: #{@uploader.counter}"
      redirect_via_turbolinks_to taxes_path
    end
  end

  private

  def build_csv
    attributes = %w(nazwa nip pit/cit pit-4 pit-8 vat)
    CSV.generate(headers: true, col_sep: ';') do |csv|
      csv << attributes
      @company_payments.each do |cp|
        if cp.current_tax_amount.present?
          vat = cp.current_tax_amount.vat
          income_tax = cp.current_tax_amount.income_tax
          pit_4 = cp.current_tax_amount.pit_4
          pit_8 = cp.current_tax_amount.pit_8
        else
          vat, income_tax, pit_4, pit_8 = 0, 0, 0, 0
        end
        csv << [cp.name, cp.nip, income_tax, pit_4, pit_8, vat]
      end
    end
  end

end
