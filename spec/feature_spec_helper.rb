require 'spec_helper'
require 'active_record_spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/poltergeist'
require 'capybara/rails'
require 'capybara/rspec'

Dir[File.expand_path('../support/pages/*.rb', __FILE__)].each { |f| require f }

def live?
  ENVied.LIVE_FEATURE_SPECS
end

def upload_photo(photo)
  if live?
    # FIXME: replace with real bucket-creation code like a user
    # AWS::S3.new(region: ENVied.AWS_REGION).buckets.create(photo.blob_bucket) unless bucket.exists?

    blobstore = AWS::S3.new(access_key_id: ENVied.TEST_ACCESS_KEY_ID, secret_access_key: ENVied.TEST_SECRET_ACCESS_KEY, region: ENVied.AWS_REGION)
    object = blobstore.buckets[photo.blob_bucket].objects[photo.blob_key]
    object.write(file: File.expand_path("../fixtures/#{photo.filename}", __FILE__)) unless object.exists?
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
