FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "#{n}@b" }
    password "abc"

    trait :authenticated do
      token "def"
    end

    factory :real_user do
      blob_username     ENV['TEST_BLOB_USERNAME']
      access_key_id     ENV['TEST_ACCESS_KEY_ID']
      secret_access_key ENV['TEST_SECRET_ACCESS_KEY']

      after(:create) do |user|
        create_blob_bucket(user: user)
      end
    end
  end
end
