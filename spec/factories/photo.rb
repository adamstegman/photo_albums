FactoryGirl.define do
  factory :photo do
    user

    trait :with_metadata do
      filename     'filename'
      content_type 'image/jpeg'
      width        800
      height       600
      taken_at     Time.at(331)
      latitude     39.1
      longitude    -94.1
      comment      "comment"
    end

    trait :uploaded do
      blob_bucket 'test-bucket'
      blob_key    'blob/key'
    end

    factory :real_photo do
      filename     'IMG_2598.jpg'
      content_type 'image/jpeg'
      width        3264
      height       2448
      taken_at     DateTime.parse('2013-05-14T23:55:53Z')
      latitude     39.050333333
      longitude    -94.60716667
      blob_bucket  'adamstegman-photo-albums-test'
      blob_key     'IMG_2598.jpg'

      association :user, factory: :real_user

      before(:create) { |photo| upload_photo(photo) }
    end
  end
end
