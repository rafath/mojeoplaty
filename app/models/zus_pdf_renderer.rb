class ZusPdfRenderer < PdfRenderer

  def initialize(zus_amount)
    super
    @zus_amount = zus_amount
    begin
      build_pdf(@zus_amount.us_account, @zus_amount.us)
      build_pdf(@zus_amount.uz_account, @zus_amount.uz)
      build_pdf(@zus_amount.fp_account, @zus_amount.fp)
    rescue
      no_record
    end
  end

  def dest_file
    File.join('payrolls', @zus_amount.user_id.to_s, @zus_amount.company_id.to_s, "zus_#{@zus_amount.period}.pdf")
  end

  def build_pdf(account, amount)
    if amount > 0
      @pdf.start_new_page if @as_new_page
      background_picture
      coordinates.each do |coordinate|
        @pdf.translate(coordinate[0], coordinate[1]) do
          @pdf.draw_text divide_string(account), at: [0, -83]
          @pdf.draw_text 'X', at: [146, -109], style: :bold, size: 20
          @pdf.draw_text divide_string(human_price(amount)), at: [252, -110]
          @pdf.font('DejaVu') do
            @pdf.draw_text amount_in_words.translate_price(amount), at: [0, -137], size: 12
            @pdf.draw_text @zus_amount.company.name, at: [0, -164]
            # @pdf.draw_text 'Super Firma Romana z Taxi Sp. z o.o.', at: [0, -191]
          end
          company_info
        end
      end
      @as_new_page = true
    end
  end

  private

  def background_picture
    filename = 'app/assets/images/transfer_zus.png'
    @pdf.image filename, at: [0, 830], fit: [500, 800]
  end

  def coordinates
    [[30, 830], [30, 481]]
  end

  def company_info
    @pdf.draw_text divide_string(@zus_amount.company.nip), at: [0, -218]
    @pdf.draw_text 'R', at: [181, -218]
    @pdf.draw_text divide_string(@zus_amount.company.regon), at: [220, -218]
    @pdf.draw_text 'S', at: [-2, -245], style: :bold
    @pdf.draw_text '0 1', at: [30, -245]
    @pdf.draw_text current_period, at: [82, -245]
  end

  def current_period
    divide_string(sprintf('%02d%4d', @zus_amount.period.month, @zus_amount.period.year))
  end

end