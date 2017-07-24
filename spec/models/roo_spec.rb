require 'rails_helper'
# require 'roo'

describe 'Roo' do

  xit 'can open xls files' do


    file = Roo::Spreadsheet.open('spec/fixtures/podatki.ods')
    # xlsx = Roo::Excelx.new("./new_prices.xlsx")
    # xlsx = Roo::Spreadsheet.open('./rails_temp_upload', extension: :xlsx)

    # puts file.info
    # puts file.sheets

    # file.each_row do |row|
    #   puts row.inspect
    # end

    # csv
    # csv = file.sheet(0).to_csv
    # CSV.parse(csv, col_sep: ',', headers: true) do |row|
    #   puts row[1]
    # end
  end

end