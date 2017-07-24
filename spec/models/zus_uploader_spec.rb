require 'rails_helper'

describe ZusUploader do

  let!(:user) { create(:user) }
  let!(:company) { create(:company, user: user, nip: '845-300-20-32') }
  let!(:company1) { create(:company, user: user, nip: '344324234234') }
  let!(:company2) { create(:company, user: user, nip: '846-166-18-45') }
  let!(:company3) { create(:company, user: user, nip: '846-166-18-90') }

  it 'can upload zus csv file' do

    expect(ZusAmount.where('period=?', ZusAmount.current_period).count).to eq 0

    file = Rack::Test::UploadedFile.new('spec/fixtures/zus_uploader1.csv', 'text/csv')
    uploader = ZusUploader.new(user, file)

    expect(uploader.upload_file('zus_payments')).to be true

    companies = user.companies.includes(:current_zus_amount)
    expect(companies.count).to eq 4
    expect(ZusAmount.where('period=?', ZusAmount.current_period).count).to eq 3

    expect(company.current_zus_amount.us).to eq 340.45
    expect(company.current_zus_amount.uz).to eq 120.45
    expect(company.current_zus_amount.fp).to eq 110
    expect(company1.current_zus_amount.us).to eq 90.45
    expect(company1.current_zus_amount.uz).to eq 455.45
    expect(company1.current_zus_amount.fp).to eq 121.90
    expect(company1.current_zus_amount.user_id).to eq user.id
    expect(company1.current_zus_amount.company_id).to eq company1.id

    file2 = Rack::Test::UploadedFile.new('spec/fixtures/zus_uploader1.csv', 'text/csv')
    uploader = ZusUploader.new(user, file2)

    expect(uploader.upload_file('zus_payments.csv')).to be true
    expect(uploader.counter).to eq 3
    expect(ZusAmount.where('period=?', ZusAmount.current_period).count).to eq 3
    expect(company.current_zus_amount.us).to eq 340.45
    expect(company1.current_zus_amount.fp).to eq 121.90

  end

  it 'cannot upload invalid file' do
    file = Rack::Test::UploadedFile.new('spec/fixtures/invalid.txt', 'text/txt')
    uploader = ZusUploader.new(user, file)
    expect(uploader.upload_file('zus_payments.csv')).to include 'Niepoprawny format pliku (tylko CSV)'
  end

  it 'raise error with invalid options for csv file' do
    file = Rack::Test::UploadedFile.new('spec/fixtures/zus_uploader1.csv')
    uploader = ZusUploader.new(user, file, {col_sep: '\t'})
    uploader.upload_file('zus.csv')

    expect(uploader.valid?).to eq false
    expect(uploader.errors).to include 'Błędnie sformatowany plik CSV'
  end

end