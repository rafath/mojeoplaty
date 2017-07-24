FactoryGirl.define do
  factory :tax_office do
    sequence(:name) { |n| "#{n} Urząd Skarbowy Augustów" }
    address 'ul. Żabia 7'
    bank_name ''
    vat_account '52101010490213402222000000'
    cit_account '05101010490213402221000000'
    pit_account '02101010490213402223000000'
    pcc_account '93101010490213402227000000'
    postcode '16-300'
    city 'Augustów'
  end

end
