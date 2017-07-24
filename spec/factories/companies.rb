FactoryGirl.define do
  factory :company do
    association :user, factory: :user
    association :tax_office, factory: :tax_office
    name Faker::Company.name
    sequence(:nip) { |n| "845-230-20-3#{n}" }
    sequence(:regon) { |n| "200838334#{n}"}
    phone Faker::PhoneNumber.phone_number
    email Faker::Internet.email
    vat_type 'vat-7'
    tax_type 'pit-5l'
    has_employees true
  end

end
