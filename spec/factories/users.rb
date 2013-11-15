FactoryGirl.define do
  factory :user do
    
    sequence(:username)   { |n| "test_user_#{n}" }
    sequence(:email)      { |n| "test_user_#{n}@example.com" }
    password              "test1234"
    password_confirmation "test1234"
  end
end