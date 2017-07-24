class CompanyUploader < UploadCsv

  def parse_file
    CSV.foreach(@file_path, @options) do |row|
      name, nip, regon, email, contact_person, phone, vat_type, tax_type, has_employees, tax_office_id = row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7], row[8], row[9]
      attributes = {
          name: titleize(name),
          nip: nip,
          regon: regon,
          email: email.to_s.downcase,
          phone: phone,
          vat_type: vat_type.to_s.downcase,
          tax_type: tax_type.to_s.downcase,
          has_employees: has_employees.to_i > 0 ? true : false,
          tax_office_id: tax_office_id,
          contact_person: contact_person.nil? ? '' : Unicode::capitalize(contact_person),
          user: @user
      }
      company = Company.by_nip(nip).first || Company.new
      company.attributes = attributes
      set_counter if company.save
    end
  end

  private

  def titleize(str)
    stop_words = %w(z o.o. zoo s.a i sc phu pphu ph pw fhu zhu xx xxi sj s.j s.c. s.c p.h.)
    new_str = []
    str.split(' ').each do |s|
      s = Unicode::capitalize(s) unless stop_words.include? s.downcase
      new_str << s
    end
    new_str.join(' ')
  end
end
