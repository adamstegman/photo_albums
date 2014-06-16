require 'spec_helper'
require 'active_record_spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/poltergeist'
require 'capybara/rails'
require 'capybara/rspec'

Capybara.default_driver = :poltergeist
Capybara.javascript_driver = :poltergeist

Dir[File.expand_path('../support/pages/*.rb', __FILE__)].each { |f| require f }

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.before(:each, type: :feature) do
    WebMock.allow_net_connect!
  end

  config.after(:each, type: :feature) do
    WebMock.disable_net_connect!(allow_localhost: true)
  end

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

def upload_photo(photo)
  # FIXME: replace with real bucket-creation code like a user
  # AWS::S3.new(region: ENV['AWS_REGION']).buckets.create(photo.blob_bucket) unless bucket.exists?

  blobstore = AWS::S3.new(access_key_id: ENV['TEST_ACCESS_KEY_ID'], secret_access_key: ENV['TEST_SECRET_ACCESS_KEY'], region: ENV['AWS_REGION'])
  object = blobstore.buckets[photo.blob_bucket].objects[photo.blob_key]
  object.write(file: File.expand_path("../fixtures/#{photo.filename}", __FILE__)) unless object.exists?
end
