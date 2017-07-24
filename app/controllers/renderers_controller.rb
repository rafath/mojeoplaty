class RenderersController < ApplicationController

  before_filter :load_company

  def zus
    @pdf = ZusPdfRenderer.new(@company.current_zus_amount)
    respond_format('oplaty_zus.pdf')
  end

  def tax
    @pdf = TaxPdfRenderer.new(@company.current_tax_amount)
    respond_format('podatki.pdf')
  end

  def vat
    @pdf = VatPdfRenderer.new(@company.current_tax_amount)
    respond_format('podatek_vat.pdf')
  end

  def mail

    zus = ZusPdfRenderer.new(@company.current_zus_amount)
    zus.render_file
    PaymentsMailer.zus(@company.current_zus_amount, zus.dest_file, current_accountant.email).deliver_now

    tax = TaxPdfRenderer.new(@company.current_tax_amount)
    tax.render_file
    PaymentsMailer.tax(@company.current_tax_amount, tax.dest_file, current_accountant.email).deliver_now

    vat = VatPdfRenderer.new(@company.current_tax_amount)
    vat.render_file
    PaymentsMailer.vat(@company.current_tax_amount, vat.dest_file, current_accountant.email).deliver_now

    PaymentsMailer.payroll(@company.payroll, current_accountant.email).deliver_now

    render layout: false
  end

  def respond_format(filename)
    respond_to do |format|
      format.pdf do
        send_data @pdf.render, send_pdf_inline_headers(filename)
      end
    end
  end

  private

  def send_pdf_inline_headers(filename)
    {
        filename: filename,
        type: 'application/pdf',
        disposition: 'inline'
    }
  end

  def load_company
    @company = current_accountant.companies.where(token: (params[:token])).first
  end


end
