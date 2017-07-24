require 'rails_helper'

describe CompanyUploader do

  let!(:user) { create(:user) }
  let!(:company) { create(:company, name: 'company', user: user, nip: '845-300-20-32') }
  let!(:company1) { create(:company, name: 'company 1', user: user, nip: '344-324-23-42') }
  let!(:company2) { create(:company, name: 'company 2', user: user, nip: '846-166-18-45') }
  let!(:company3) { create(:company, name: 'company 3',  user: user, nip: '892-300-30-32') }

  let!(:file) { Rack::Test::UploadedFile.new('spec/fixtures/companies4.csv', 'text/csv') }

  it 'can upload company csv' do

    create(:tax_office)
    create(:tax_office)

    expect(Company.count).to eq 4
    expect(Company.by_nip('845-300-20-32').first.name).to eq 'company'

    uploader = CompanyUploader.new(user, file)

    # TODO update fixture filename after changing it content
    expect(uploader.upload_file('companies.csv')).to be true
    expect(uploader.counter).to eq 8

    expect(Company.count).to eq 8
    expect(Company.by_nip('845-300-20-32').first.name).to eq 'Allegro S.A'
    expect(Company.by_nip('320-300-30-22').first.name).to eq 'Alkhameri'
    expect(Company.by_nip('320-300-30-22').first.regon).to eq '300342211'

  end

  it 'gets errors for invalid file' do
    uploader = CompanyUploader.new(user, file, {col_sep: ',' })
    uploader.upload_file('companies.csv')
    expect(uploader.valid?).to eq false
    expect(uploader.errors).to include 'Błędnie sformatowany plik CSV'
  end
end
