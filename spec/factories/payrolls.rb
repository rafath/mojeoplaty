FactoryGirl.define do
  factory :payroll do
    association :user, factory: :user
    association :company, factory: :company
    period Payroll.next_period
    filename '1234.pdf'
  end
end