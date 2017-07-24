require 'rails_helper'
require 'prawn'

describe 'PdfRenderer wit Prawn' do

  let!(:user) { create(:user) }
  let!(:company) { create(:company, user: user) }

  it 'generates zus pdf for given zus_amount' do
    zus_amount = create(:zus_amount, user: user, company: company)
    pdf = ZusPdfRenderer.new(zus_amount)
    pdf.render_file
    expect(File.exist?(pdf.dest_file)).to eq true
  end

  it 'generates tax pdf for given tax_amount' do
    user1 = create(:user)
    company1 = create(:company, user: user1)
    tax_amount = create(:tax_amount, company: company1, user: user1)
    pdf = TaxPdfRenderer.new(tax_amount)
    pdf.render_file
    expect(File.exist?(pdf.dest_file)).to eq true
  end

  it 'generates vat pdf for given vat_amount' do
    user1 = create(:user)
    company1 = create(:company, user: user1)
    tax_amount = create(:tax_amount, company: company1, user: user1)
    pdf = VatPdfRenderer.new(tax_amount)
    pdf.render_file
    expect(File.exist?(pdf.dest_file)).to eq true
  end

  it 'generates vat pdf for given vat_7k-amount' do
    company.update_attributes(tax_type: 'cit-8', vat_type: 'vat-7k')
    tax_amount = create(:tax_amount, user: user, company: company)
    TaxPdfRenderer.new(tax_amount)
  end

  it 'generates vat pdf for given vat_7k-amount' do
    company.update_attributes(tax_type: 'cit-8', vat_type: 'vat-7k')
    tax_amount = create(:tax_amount, user: user, company: company)
    pdf = VatPdfRenderer.new(tax_amount)
    pdf.render_file
    expect(File.exist?(pdf.dest_file)).to eq true
  end


  xit 'can generate pdf with zus image' do
    words = AmountInWords.new

    pdf = Prawn::Document.new(page_size: 'A4', margin: [0, 50])
    filename = 'app/assets/images/transfer_zus.png'
    pdf.font_families.update(
        'DejaVu' => {
            bold: 'app/assets/fonts/DejaVuSans-Bold.ttf',
            italic: 'app/assets/fonts/DejaVuSans-Italic.ttf',
            normal: 'app/assets/fonts/DejaVuSans.ttf'
        }
    )
    pdf.font 'Courier'
    pdf.font_size 14

    pdf.image filename, at: [0, 830], fit: [500, 800]
    [[30, 830], [30, 481]].each do |coordinate|
      pdf.translate(coordinate[0], coordinate[1]) do
        pdf.draw_text '7 3 1 0 1 0 1 0 2 3 0 0 0 0 2 6 1 3 9 5 3 0 0 0 0 0', at: [0, -83]
        pdf.draw_text 'X', at: [146, -109], style: :bold, size: 20
        pdf.draw_text '1 9 4 5 , 4 5', at: [252, -110]
        pdf.font('DejaVu') do
          pdf.draw_text words.translate_price(1945.45), at: [0, -137], size: 12
          pdf.draw_text 'Super Firma Romana z Taxi Sp. z o.o.', at: [0, -164]
          pdf.draw_text 'Super Firma Romana z Taxi Sp. z o.o.', at: [0, -191]
        end
        pdf.draw_text '8 4 6 1 6 6 1 8 4 4', at: [0, -218]
        pdf.draw_text 'R', at: [181, -218]
        pdf.draw_text '2 0 0 8 5 3 3 4 4', at: [220, -218]
        pdf.draw_text 'M', at: [-2, -245], style: :bold
        pdf.draw_text '0 1', at: [30, -245]
        pdf.draw_text '1 2 2 0 1 5', at: [82, -245]
      end
    end
    pdf.start_new_page

    pdf.image filename, at: [0, 830], fit: [500, 800]
    [[30, 830], [30, 481]].each do |coordinate|
      pdf.translate(coordinate[0], coordinate[1]) do
        pdf.draw_text '7 1 1 0 1 0 1 0 2 3 0 0 0 0 2 6 1 3 9 5 3 0 0 0 0 0', at: [0, -83]
        pdf.draw_text 'X', at: [146, -109], style: :bold, size: 20
        pdf.draw_text '9 4 5 , 4 5', at: [252, -110]
        pdf.font('DejaVu') do
          pdf.draw_text words.translate_price(945.45), at: [0, -137], size: 12
          pdf.draw_text 'Super Firma Ubser z Taxi Sp. z o.o.', at: [0, -164]
          pdf.draw_text 'Super Firma Ubser z Taxi Sp. z o.o.', at: [0, -191]
        end
        pdf.draw_text '8 4 6 1 6 6 1 8 4 4', at: [0, -218]
        pdf.draw_text 'R', at: [181, -218]
        pdf.draw_text '2 0 0 8 5 3 3 4 4', at: [220, -218]
        pdf.draw_text 'M', at: [-2, -245], style: :bold
        pdf.draw_text '0 1', at: [30, -245]
        pdf.draw_text '1 2 2 0 1 5', at: [82, -245]
      end
    end
    pdf.start_new_page

    # pdf.image filename, at: [0, 830], fit: [500, 800]
    [[30, 830], [30, 481]].each do |coordinate|
      pdf.translate(coordinate[0], coordinate[1]) do
        pdf.draw_text '1 2 2 0 1 0 1 0 2 3 0 0 0 0 2 6 1 3 9 5 3 0 0 0 0 0', at: [0, -83]
        pdf.draw_text 'X', at: [146, -109], style: :bold, size: 20
        pdf.draw_text '4 5 , 4 5', at: [252, -110]
        pdf.font('DejaVu') do
          pdf.draw_text words.translate_price(45.45), at: [0, -137], size: 12
          pdf.draw_text 'Super Firma Ubser z Taxi Sp. z o.o.', at: [0, -164]
          pdf.draw_text 'Super Firma Ubser z Taxi Sp. z o.o.', at: [0, -191]
        end
        pdf.draw_text '8 4 6 1 6 6 1 8 4 4', at: [0, -218]
        pdf.draw_text 'R', at: [181, -218]
        pdf.draw_text '2 0 0 8 5 3 3 4 4', at: [220, -218]
        pdf.draw_text 'M', at: [-2, -245], style: :bold
        pdf.draw_text '0 1', at: [30, -245]
        pdf.draw_text '1 2 2 0 1 5', at: [82, -245]
      end
    end

    # pdf.translate(30, 481) do
    #   pdf.draw_text '7 3 1 0 1 0 1 0 2 3 0 0 0 0 2 6 1 3 9 5 3 0 0 0 0 0', at: [0, -83]
    #   pdf.draw_text 'X', at: [132, -106], style: :bold
    # end
    pdf.render_file('spec/fixtures/zus.pdf')

    # size = 600
    # pdf.bounding_box([0, pdf.cursor], :width => size, :height => size) do
    #   pdf.image filename, :fit => [size, size]
    #   pdf.stroke_bounds
    # end

    # puts Prawn::Measurements
    # puts Prawn::Document::PageGeometry::SIZES['A4'][1]

    # Prawn::Document.generate('cos.pdf') do
    #   stroke_axis
    #   stroke_circle [0, 0], 10
    #   bounding_box([100, 300], :width => 300, :height => 200) do
    #     stroke_bounds
    #     stroke_circle [0, 0], 10
    #   end
    # end

    # Example 2 background image
    # pdf.start_new_page
    #
    # # Record the original y value (cause y=0 is the bottom of the page)
    # y_position = pdf.cursor
    # pdf.text "The image will be above."
    # # Put the image with absolute positioning
    # pdf.image filename, :at => [50, y_position]
    # # Write on top of the image
    # pdf.text "The image will be below."
    #
    # # Example 3 scaled images
    # pdf.start_new_page
    # pdf.text "Scale by setting only the width"
    # pdf.image filename, :width => 150
    # pdf.move_down 20
    # pdf.text "Scale by setting only the height"
    # pdf.image filename, :height => 100
    # pdf.move_down 20
    # pdf.text "Stretch to fit the width and height provided"
    # pdf.image filename, :width => 500, :height => 100
    #
    # send_data pdf.render, :filename => 'x.pdf', :type => 'application/pdf', :disposition => 'inline'
  end

  xit 'can generate taxes form' do
    pdf = Prawn::Document.new(margin: [0, 50], page_size: 'A4')
    filename = 'app/assets/images/transfer_taxes.png'
    pdf.font_families.update(
        'DejaVu' => {
            bold: 'app/assets/fonts/DejaVuSans-Bold.ttf',
            italic: 'app/assets/fonts/DejaVuSans-Italic.ttf',
            normal: 'app/assets/fonts/DejaVuSans.ttf'
        }
    )
    pdf.font 'Courier'
    pdf.font_size 14
    pdf.image filename, at: [0, 830], fit: [500, 800]
    # pdf.translate() do

    [[30, 890], [30, 541]].each do |coordinate|
      pdf.translate(coordinate[0], coordinate[1]) do
        pdf.font('DejaVu') do
          pdf.draw_text 'Urząd Skarbowy Augustów', at: [0, -87]
          pdf.draw_text 'Ul. Żabia 7, 16-300 Augustów', at: [0, -117]
        end
        pdf.draw_text '7 3 1 0 1 0 1 0 2 3 0 0 0 0 2 6 1 3 9 5 3 0 0 0 0 0', at: [0, -145]
        pdf.draw_text 'X', at: [150, -175], style: :bold, size: 20
        pdf.draw_text '9 4 5 , 4 5', at: [252, -175]
        pdf.font('DejaVu') do
          pdf.draw_text 'dziewięćset pięćdziesiąt pięć złotych, 60 gr', at: [0, -203]
          pdf.draw_text 'Super Firma Romana z Taxi Sp. z o.o.', at: [0, -231]
          pdf.draw_text 'Super Firma Romana z Taxi Sp. z o.o.', at: [0, -259]
        end
        pdf.draw_text '8 4 6 1 6 6 1 8 4 4', at: [0, -287]
        pdf.draw_text 'N', at: [252, -287]
        pdf.draw_text '1 5 K 1 2', at: [315, -287]
        # pdf.draw_text 'K', at: [320, -265]
        # pdf.draw_text '1 5', at: [82, -265]
      end
    end
    pdf.render_file('spec/fixtures/tax.pdf')
  end

end