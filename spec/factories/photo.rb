FactoryGirl.define do
  factory :photo do
    factory :real_photo, traits: [:real]
  end

  trait :real do
    content { File.open('spec/fixtures/egg_small.jpg') }
  end
end
