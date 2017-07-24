require 'rails_helper'

describe 'User can manage payrolls' do

  let!(:user) { create(:user) }
  before(:each) do
    login_as(user)
  end

  it 'can download payroll' do
    company = create(:company, user: user)
    payroll = create(:payroll, user: user, company: company, filename: '7e5f582e4ff5a450f468dac4d3690c.pdf')
    allow(payroll).to receive(:file_path).and_return(File.join(Rails.root, 'spec', 'fixtures', 'payrolls.pdf'))

    visit download_payrolls_path(company.id, payroll.id)

    expect(response_headers['Content-Type']).to eq 'application/pdf'
    expect(response_headers['Content-Disposition']).to include 'lista_plac'

  end
end
