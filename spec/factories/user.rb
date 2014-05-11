FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "#{n}@b" }
    password "abc"

    trait :authenticated do
      token "def"
    end
  end
end
