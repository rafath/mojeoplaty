class VatPdfRenderer < PdfRenderer

  def initialize(tax_amount)
    super
    @tax_amount = tax_amount
    begin
      build_pdf(@tax_amount.vat)
    rescue
      no_record
    end
  end

  def dest_file
    File.join('payrolls', @tax_amount.user_id.to_s, @tax_amount.company_id.to_s, "vat_#{@tax_amount.period}.pdf")
  end

  def build_pdf(amount)
    if amount > 0
      background_picture
      coordinates.each do |coordinate|
        @pdf.translate(coordinate[0], coordinate[1]) do
          tax_office
          @pdf.draw_text divide_string(@tax_amount.company.tax_office.vat_account), at: [0, -145]
          @pdf.draw_text 'X', at: [150, -175], style: :bold, size: 20
          @pdf.draw_text divide_string(human_price(amount)), at: [252, -175]

          @pdf.font('DejaVu') do
            @pdf.draw_text amount_in_words.translate_price(amount), at: [0, -203], size: 12
          end
          company_info
          current_period
          payment_type
        end
      end
    else
      @pdf.move_down 100
      @pdf.font('DejaVu') do
        @pdf.text 'Kwota Podatku VAT wynosi 0 zł - sprawdź czy poprawnie wypełniono dane dla firmy', color: 'FF0000'
      end
    end
  end

  private

  def background_picture
    filename = 'app/assets/images/transfer_taxes.png'
    @pdf.image filename, at: [0, 830], fit: [500, 800]
  end

  def coordinates
    [[30, 890], [30, 541]]
  end

  def company_info
    @pdf.font('DejaVu') do
      @pdf.draw_text @tax_amount.company.name, at: [0, -231]
      # another line: at: [0, -259]
    end
    @pdf.draw_text divide_string(@tax_amount.company.nip), at: [0, -287]
    @pdf.draw_text 'N', at: [252, -287]
  end

  def tax_office
    @pdf.font('DejaVu') do
      @pdf.draw_text @tax_amount.company.tax_office.name, at: [0, -87]
      @pdf.draw_text "#{@tax_amount.company.tax_office.address}, #{@tax_amount.company.tax_office.postcode} #{@tax_amount.company.tax_office.city}", at: [0, -117]
    end
  end

  def current_period
    if @tax_amount.company.vat_7k?
      period = current_quarter_period
    else
      period = (sprintf('%2dM%02d', @tax_amount.period.year%100, @tax_amount.period.month))
    end
    @pdf.draw_text divide_string(period), at: [317, -287]
  end

  def current_quarter_period
    q = ((@tax_amount.period.month-1) / 3) + 1
    sprintf('%2dK%02d', @tax_amount.period.year%100, q)
  end

  def payment_type
    @pdf.draw_text divide_string(@tax_amount.company.vat_type.upcase), at: [0, -315]
  end

end