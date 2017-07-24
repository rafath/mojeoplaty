class CompaniesController < ApplicationController

  before_filter :authenticate_with_session, :restrict_access
  before_filter :load_company, except: [:index, :create]
  before_filter :companies_crumb

  def index
    @companies = current_user.companies.includes(:tax_office).page(params[:page])
    respond_to do |format|
      format.html
      format.csv do
        send_data build_csv, filename: 'firmy.csv'
      end
    end
  end

  def new
    add_breadcrumb 'Nowa Firma'
  end

  def create
    @company = Company.new(company_params)
    @company.user = current_user
    if @company.save
      flash[:success] = 'Firma została dodana'
      redirect_via_turbolinks_to companies_path
    end
  end

  def edit
    add_breadcrumb @company.name
  end

  def update
    @company.update_attributes(company_params)
    if @company.save
      flash[:success] = 'Dane zostały zmienione'
      redirect_via_turbolinks_to companies_path
    end
  end

  def destroy
    render layout: false
    @company.update_attribute(:is_deleted, true)
  end

  def upload
    @uploader = CompanyUploader.new(current_user, params[:csv], csv_params.to_h)
    @uploader.upload_file("#{current_user.id}_companies.csv")
    if @uploader.valid?
      flash[:success] = "Pomyślnie zaktualizowano rekordów: #{@uploader.counter}"
      redirect_via_turbolinks_to(companies_path)
    end
  end

  private

  def load_company
    @company = params[:id].present? ? current_user.companies.find(params[:id]) : Company.new
  end

  def company_params
    params.require(:company)
        .permit(:tax_office_id, :name, :email, :contact_person, :cc_emails, :nip, :phone, :vat_type, :tax_type, :has_employees, :send_sms, :regon)
  end

  def csv_params
    params.require(:csv_settings).permit(:col_sep)
  end

  def build_csv
    # attr = %w(ID nazwa konto_vat)
    # CSV.generate(headers: attr, col_sep: ';', quote_char: '"', force_quotes: true) do |csv|
    #   TaxOffice.all.order('id').each do |t|
    #     csv << [t.id, t.full_name, t.vat_account]
    #   end
    # end
    attributes = ['nazwa firmy', 'nip', 'regon', 'email', 'osoba kontaktowa', 'telefon', 'vat: [vat-7 lub vat-7k]', 'podatek [cit-8 lub pit-5 lub pit-5l]', 'pracownicy [1 lub 0]', "ID Urzędu Skarbowego (pobierz z #{tax_offices_url})"]
    CSV.generate(headers: true, col_sep: ';', quote_char: '"', force_quotes: true) do |csv|
      csv << attributes
      @companies.each do |company|
        csv << [company.name, company.formatted_nip, company.regon, company.email, company.contact_person, company.phone, company.vat_type, company.tax_type, company.has_employees ? '1' : '0', company.tax_office_id]
      end
    end
  end

  def companies_crumb
    add_breadcrumb 'Lista Firm', companies_path
  end

end
