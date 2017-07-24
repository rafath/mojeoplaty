class ZusController < ApplicationController

  before_filter :authenticate_with_session

  def index
    @company_payments = current_accountant.companies.includes(:before_current_zus_amount)
    respond_to do |format|
      format.html do
        add_breadcrumb 'Nowe opłaty ZUS'
      end
      format.csv do
        send_data build_csv, filename: 'oplaty_zus.csv'
      end
    end
  end

  def save
    company = current_accountant.companies.find(params[:company])
    if company.current_zus_amount.present?
      company.current_zus_amount.attributes = {params[:type].to_sym => params[:value]}
    else
      company.create_current_zus_amount(params[:type].to_sym => params[:value], user: current_accountant)
    end
    company.current_zus_amount.save
    render text: 'ok'
  end

  def upload
    @uploader = ZusUploader.new(current_accountant, params[:csv], option_params)
    if @uploader.upload_file('zus_payments') === true
      flash[:success] = "Ilość poprawnie wczytanych rekordów: #{@uploader.counter}"
      redirect_via_turbolinks_to zus_edit_path
    end
  end

  def copy
    company_payments = current_accountant.companies.includes(:before_current_zus_amount)
    counter = 0
    company_payments.each do |company|
      if company.before_current_zus_amount.present?
        counter += 1
        zus_amount = ZusAmount.by_company_and_period(company.id).first || ZusAmount.new
        zus_amount.attributes = {
            user: current_user,
            company_id: company.id,
            us: company.before_current_zus_amount.us,
            uz: company.before_current_zus_amount.uz,
            fp: company.before_current_zus_amount.fp
        }
        zus_amount.save
      end
    end
    flash[:success] = "Ilość skopiowanych rekordów: #{counter}"
    redirect_via_turbolinks_to zus_edit_path
  end

  def edit
    add_breadcrumb 'Bieżące opłaty ZUS'
    @company_payments = current_accountant.companies.includes(:current_zus_amount)
  end

  private

  def build_csv
    attributes = %w(nazwa nip us-51 uz-52 fp-53)
    CSV.generate(headers: true, col_sep: ';') do |csv|
      csv << attributes
      @company_payments.each do |cp|
        if cp.before_current_zus_amount.present?
          us = cp.before_current_zus_amount.us
          uz = cp.before_current_zus_amount.uz
          fp = cp.before_current_zus_amount.fp
        else
          us, uz, fp = 0, 0, 0
        end
        csv << [cp.name, cp.nip, us, uz, fp]
      end
    end
  end

end
