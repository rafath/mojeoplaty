require 'securerandom'
class PayrollUploader
  include Owner

  attr_reader :errors, :filename

  def initialize(user, company, file)
    @user = user
    @company = company
    @file = file
    @errors = []
    validate_file
  end

  def upload_file
    begin
      move_uploaded_file
    rescue
      @errors << 'Wystąpił problem z plikiem'
    end
  end

  def valid?
    @errors.blank?
  end

  private

  def validate_file
    @errors << 'Waga pliku jest za duża' if @file.tempfile.size > 5.megabytes
    @errors << 'Niepoprawny format pliku (pdf, doc, xls)' unless %w(.pdf .doc .xls .docx .xlsx).include? File.extname(@file.original_filename)
    if valid?
      create_company_dir
    else
      remove_uploaded_file
    end
  end

  def remove_uploaded_file
    @file.tempfile.unlink
  end

  def move_uploaded_file()
    destiny_file = File.join(@company_dir, create_filename)
    FileUtils.move @file.tempfile.path, destiny_file
  end

  def create_company_dir
    @company_dir ||= begin
      user_dir = File.join('payrolls', @user.id.to_s)
      Dir.mkdir(user_dir) unless Dir.exist? user_dir
      company_dir = File.join(user_dir, @company.id.to_s)
      Dir.mkdir(company_dir) unless Dir.exist? company_dir
      company_dir
    end
  end

  def create_filename
    @filename ||= SecureRandom.hex(15).to_s << File.extname(@file.original_filename)
  end
end