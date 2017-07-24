FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "joe_shmoe_#{n}@example.pl" }
    firstname Faker::Name.first_name
    lastname Faker::Name.last_name
    password 'pass1234'
    password_confirmation 'pass1234'
    sequence(:nip) { |n| "186-145-33-2#{n}" }
  end

end
