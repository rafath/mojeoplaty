class PdfRenderer
  include ActionView::Helpers::NumberHelper
  attr_accessor :pdf, :as_new_page

  def initialize(filename)
    @pdf = Prawn::Document.new(page_size: 'A4', margin: [0, 50])
    @pdf.font_families.update(
        'DejaVu' => {
            bold: 'app/assets/fonts/DejaVuSans-Bold.ttf',
            italic: 'app/assets/fonts/DejaVuSans-Italic.ttf',
            normal: 'app/assets/fonts/DejaVuSans.ttf'
        }
    )
    @pdf.font 'Courier'
    @pdf.font_size 14
  end

  def render
    @pdf.render
  end

  def render_file
    @pdf.render_file(dest_file)
  end

  def divide_string(str)
    str.to_s.gsub(/\s+/, '').chars.join(' ')
  end

  def amount_in_words
    @amount_in_words ||= AmountInWords.new
  end

  def human_price(price)
    number_to_currency(price, {unit: '', separator: ',', delimiter: ' ', format: '%n'})
  end

  def no_record
    @pdf.font('DejaVu') do
      @pdf.move_down 100
      @pdf.text 'Firma nie posiada uzupełnionych opłat - sprawdź dane w systemie', color: 'FF0000'
    end
  end

  def rendered?
    File.exist? dest_file
  end

end