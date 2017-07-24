FactoryGirl.define do
  factory :zus_amount do
    association :user, factory: :user
    association :company, factory: :company
    period ZusAmount.current_period
    sequence(:us) { |n| "#{n+1}9#{n}.35" }
    sequence(:uz) { |n| "#{n+1}2#{n}.55" }
    sequence(:fp) { |n| "#{n+1}0#{n}.15" }
  end
end
