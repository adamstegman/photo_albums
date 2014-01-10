FactoryGirl.define do
  factory :photo do
    factory :real_photo, traits: [:real]
  end

  trait :fixture do
    content { File.open('spec/fixtures/flag.png') }
  end

  trait :real do
    content { File.open('spec/fixtures/IMG_2598.jpg') }
  end
end
