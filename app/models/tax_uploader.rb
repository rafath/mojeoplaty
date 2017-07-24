class TaxUploader < UploadCsv

  def parse_file
    CSV.foreach(@file_path, @options) do |row|
      nip, income_tax, pit_4, pit_8, vat = row[1], row[2], row[3], row[4], row[5]
      payments = {income_tax: income_tax, pit_4: pit_4, pit_8: pit_8, vat: vat}
      build_tax_amount(nip, payments) if nip.present?
    end
  end

  private

  def build_tax_amount(nip, payments)

    company = @user.companies.by_nip(nip)
    if company.present?
      company = company.first
      if company.current_tax_amount.present?
        company.current_tax_amount.attributes = payments
      else
        payments[:user] = @user
        payments[:employee] = @employee
        company.create_current_tax_amount(payments)
      end
      company.current_tax_amount.save
      set_counter
    end
  end
end