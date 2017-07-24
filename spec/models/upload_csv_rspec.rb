require 'rails_helper'

describe UploadCsv do

  let!(:user) { create :user }
  let!(:file) { Rack::Test::UploadedFile.new('spec/fixtures/zus_uploader.csv', 'text/csv') }
  let!(:invalid_file) { Rack::Test::UploadedFile.new('spec/fixtures/invalid.txt', 'text/txt') }

  it 'set user dirs' do
    UploadCsv.new(user, file)
    expect(Dir.exist?("tmp/csv/#{user.id}/")).to eq true
  end

  it 'validates uploaded file' do
    csv = UploadCsv.new(user, file)
    expect(csv.valid?).to eq true

    csv = UploadCsv.new(user, invalid_file)
    expect(csv.valid?).to eq false
    expect(csv.errors).to include('Niepoprawny format pliku (tylko CSV)')
  end

  it 'sets proper encoding for uploaded file' do
    csv = UploadCsv.new(user, file)
    csv.set_utf8_encoding('zus.csv')
    expect(csv.file_path).to eq "tmp/csv/#{user.id}/zus.csv"
    expect(File.exist?(csv.file_path)).to eq true
  end
end