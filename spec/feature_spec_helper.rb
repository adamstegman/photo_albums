require 'spec_helper'
require 'active_record_spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/poltergeist'
require 'capybara/rails'
require 'capybara/rspec'

Capybara.javascript_driver = :poltergeist

Dir[File.expand_path('../support/pages/*.rb', __FILE__)].each { |f| require f }
