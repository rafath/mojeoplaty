require 'rails_helper'

RSpec.describe TaxOffice, type: :model do

  it 'can create short account' do
    tax_office = create(:tax_office, pcc_account: '93 1010 1049 0213 4022 2700 0000')

    expect(tax_office.short_account('cit')).to eq '05..2100'
    expect(tax_office.short_account('vat')).to eq '52..2200'
    expect(tax_office.short_account('pit')).to eq '02..2300'
    expect(tax_office.short_account('pcc')).to eq '93..2700'

  end
end
