FactoryGirl.define do
  factory :applicant do
    sequence(:first_name) { |n| "joe" }
    sequence(:last_name) { |n| "blogs" }
    sequence(:email) { |n| "test_email#{n}@example.com" }
    cell {"4151231234"}
    zipcode {"94109"}
  end
end
