FactoryGirl.define do
  factory :tax_amount do
    association :user, factory: :user
    association :company, factory: :company
    period TaxAmount.current_period
    sequence(:vat) { |n| "#{n}55.40"}
    sequence(:income_tax) { |n| "#{n}80.05"}
    sequence(:pit_4) { |n| "#{n}91.23"}
    sequence(:pit_8) { |n| "#{n}01"}
  end
end
