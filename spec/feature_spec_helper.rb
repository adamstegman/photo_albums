require 'spec_helper'
require 'active_record_spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/poltergeist'
require 'capybara/rails'
require 'capybara/rspec'

Dir[File.expand_path('../support/pages/*.rb', __FILE__)].each { |f| require f }

def live?
  !!ENV['LIVE_FEATURE_SPECS']
end

def fixture_file_path(filename)
  File.expand_path("../fixtures/#{filename}", __FILE__)
end

# FIXME: replace with real bucket-creation code like a user
def create_blob_bucket(user: user, blob_bucket: user.blob_bucket)
  blobstore = AWS::S3.new(access_key_id: ENV['AWS_ACCESS_KEY_ID'], secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'], region: ENV['AWS_REGION'])
  bucket = blobstore.buckets[blob_bucket]
  unless bucket.exists?
    blobstore.buckets.create(blob_bucket)
    bucket = blobstore.buckets[blob_bucket]
    bucket.cors = AWS::S3::CORSRule.new(
      allowed_origins: %w(*),
      allowed_methods: %w(GET PUT),
      allowed_headers: %w(*),
      max_age_seconds: 315576000,
    )
    bucket.policy = AWS::S3::Policy.new do |policy|
      policy.allow(
        principals: %W(arn:aws:iam::#{ENV['TEST_ACCOUNT_NUMBER']}:user/#{user.blob_username}),
        actions: %w(s3:DeleteObject s3:GetObject s3:PutObject),
        resources: %W(arn:aws:s3:::#{blob_bucket}/*)
      )
    end
  end
end

def upload_photo(photo)
  if live?
    create_blob_bucket(user: photo.user, blob_bucket: photo.blob_bucket)
    blobstore = AWS::S3.new(access_key_id: ENV['TEST_ACCESS_KEY_ID'], secret_access_key: ENV['TEST_SECRET_ACCESS_KEY'], region: ENV['AWS_REGION'])
    object = blobstore.buckets[photo.blob_bucket].objects[photo.blob_key]
    object.write(file: fixture_path(photo.filename)) unless object.exists?
  end
end

Capybara.default_driver = :poltergeist
Capybara.javascript_driver = :poltergeist

if live?
  RSpec.configure do |config|
    config.before(:each, type: :feature) do
      WebMock.allow_net_connect!
    end

    config.after(:each, type: :feature) do
      WebMock.disable_net_connect!(allow_localhost: true)
    end
  end
else
  require 'vcr'

  VCR.configure do |config|
    config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
    config.hook_into :webmock
    config.ignore_localhost = true
  end

  RSpec.configure do |config|
    config.around(:each, type: :feature) do |example|
      WebMock.disable_net_connect!(allow_localhost: true)
      VCR.use_cassette(example.metadata[:full_description], allow_playback_repeats: true) do
        example.run
      end
    end

    config.before(:each, type: :feature) do
      # aws-sdk handles us-east-1 specially when crafting URLs
      ENV['AWS_REGION'] = 'us-east-1'
      ENV['AWS_ACCESS_KEY_ID'] = 'access-key-id'
      ENV['AWS_SECRET_ACCESS_KEY'] = 'secret-access-key'
    end
  end
end

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
