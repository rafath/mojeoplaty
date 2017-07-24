class ZusUploader < UploadCsv

  def parse_file
    CSV.foreach(@file_path, @options) do |row|
      nip, us, uz, fp = row[1], row[2], row[3], row[4]
      payments = {us: us, uz: uz, fp: fp}
      build_zus_amount(nip, payments) if nip.present?
    end
  end

  private

  def build_zus_amount(nip, payments)

    company = @user.companies.by_nip(nip)
    if company.present?
      company = company.first
      if company.current_zus_amount.present?
        company.current_zus_amount.attributes = payments
      else
        payments[:user] = @user
        payments[:employee] = @employee
        company.create_current_zus_amount(payments)
      end
      company.current_zus_amount.save
      set_counter
    end
  end
end