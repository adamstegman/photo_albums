# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email    "a@b"
    password "abc"

    trait :authenticated do
      token "def"
    end
  end
end
