FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "#{n}@b" }
    password "abc"

    trait :authenticated do
      token "def"
    end

    factory :real_user do
      access_key_id     ENVied.TEST_ACCESS_KEY_ID
      secret_access_key ENVied.TEST_SECRET_ACCESS_KEY
    end
  end
end
