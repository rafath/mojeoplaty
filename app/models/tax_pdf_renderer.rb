class TaxPdfRenderer < PdfRenderer

  def initialize(tax_amount)
    super
    @tax_amount = tax_amount
    begin
      build_pdf(@tax_amount.income_tax, 'pit')
      build_pdf(@tax_amount.pit_4, 'pit4')
      build_pdf(@tax_amount.pit_8, 'pit8')
    rescue
      no_record
    end
  end

  def dest_file
    File.join('payrolls', @tax_amount.user_id.to_s, @tax_amount.company_id.to_s, "tax_#{@tax_amount.period}.pdf")
  end

  def build_pdf(amount, type)
    if amount > 0
      if type == 'pit' && @tax_amount.company.tax_type.include?('cit')
        account = @tax_amount.company.tax_office.cit_account
      else
        account = @tax_amount.company.tax_office.pit_account
      end
      @pdf.start_new_page if @as_new_page
      background_picture
      coordinates.each do |coordinate|
        @pdf.translate(coordinate[0], coordinate[1]) do
          tax_office
          @pdf.draw_text divide_string(account), at: [0, -145]
          @pdf.draw_text 'X', at: [150, -175], style: :bold, size: 20
          @pdf.draw_text divide_string(human_price(amount)), at: [252, -175]

          @pdf.font('DejaVu') do
            @pdf.draw_text amount_in_words.translate_price(amount), at: [0, -203], size: 12
          end
          company_info
          current_period
          payment_type(type)
        end
      end
    end
    @as_new_page = true
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
      # @pdf.draw_text @tax_amount.company.name, at: [0, -259]
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
    period = (sprintf('%2dM%02d', @tax_amount.period.year%100, @tax_amount.period.month))
    @pdf.draw_text divide_string(period), at: [317, -287]
  end

  def payment_type(type)
    types = {
        'pit' => @tax_amount.company.tax_type.upcase,
        'pit4' => 'PIT-4',
        'pit8' => 'PIT-8'
    }
    @pdf.draw_text divide_string(types[type]), at: [0, -315]
  end

end