require 'rails_helper'

describe PayrollUploader do

  # it 'has default values after initialize' do
  #   user = create(:user)
  #   payroll = Payroll.new
  #   expect(payroll.period.to_s).to eq Payroll.next_period
  #   expect(payroll.filename).to eq "payroll_#{Payroll.next_period[0,5]}"
  # end

  it 'can upload pdf files' do
    user = create(:user)
    company = create(:company, user: user)
    file = Rack::Test::UploadedFile.new('spec/fixtures/payrolls.pdf', 'application/pdf')

    uploader = PayrollUploader.new(user, company, file)
    uploader.upload_file

    dest_file = File.join('payrolls', user.id.to_s, company.id.to_s, uploader.filename)
    expect(File.exist?(dest_file)).to be true
  end

  it 'cant upload other files' do
    user = create(:user)
    company = create(:company, user: user)
    file = Rack::Test::UploadedFile.new('spec/fixtures/invalid.txt', 'text/txt')
    uploader = PayrollUploader.new(user, company, file)

    expect(uploader.valid?).to be false

  end
end