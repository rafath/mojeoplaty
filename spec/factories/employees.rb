FactoryGirl.define do
  factory :employee do
    association :user, factory: :user
    firstname Faker::Name.first_name
    lastname Faker::Name.last_name
    sequence(:email) { |n| "employee_#{n}@dot.com"}
    password '123456'
    # password_confirmation '123456'
    plain_pass '123456'
  end

end
