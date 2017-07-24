require 'csv'

class UploadCsv
  include Owner

  attr_reader :errors, :file_path, :counter

  def initialize(user, file, options={})
    set_user(user)
    @file = file
    @errors = []
    validate_file
    build_options(options) if valid?
  end

  def upload_file(filename)
     begin
      set_utf8_encoding(filename)
      parse_file
      true
    rescue
      @errors << 'Błędnie sformatowany plik CSV'
    end
  end

  def valid?
    @errors.blank?
  end

  def set_utf8_encoding(filename)
    @file_path = "#{@user_dir}#{filename}"
    uploaded_file = File.read(@file.tempfile.path)
    detector = CharlockHolmes::EncodingDetector.new
    detected_file = detector.detect(uploaded_file)
    File.delete(@file_path) if File.exist?(@file_path)
    csv = File.open(@file_path, 'w+')
    csv.puts(uploaded_file.encode('UTF-8', detected_file[:encoding]))
    csv.close
    remove_uploaded_file
  end

  def parse_file
    raise 'Abstract method called'
  end

  private

  def validate_file
    @errors << 'Waga pliku jest za duża' if @file.tempfile.size > 5.megabytes
    @errors << 'Niepoprawny format pliku (tylko CSV)' if File.extname(@file.original_filename) != '.csv'
    if valid?
      create_user_dir
    else
      remove_uploaded_file
    end
  end

  def create_user_dir
    csv_dir = 'tmp/csv/'
    @user_dir = "#{csv_dir}#{@user.id}/"
    Dir.mkdir(csv_dir) unless Dir.exist? csv_dir
    Dir.mkdir(@user_dir) unless Dir.exist? @user_dir
  end

  def remove_uploaded_file
    @file.tempfile.unlink
  end

  def build_options(options={})
    options.symbolize_keys!
    options[:col_sep] =';' if options[:col_sep].blank?
    options[:quote_char] = '"' if options[:quote_char].blank?
    options[:headers] = true if options[:headers].blank?
    @options = options
  end

  def set_counter
    @counter ||= 0
    @counter += 1
  end

end