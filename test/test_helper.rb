ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'webmock/minitest'
require "minitest/unit"
require "mocha/mini_test"

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  ENV['MAILGUN_KEY'] = 'asdfasdfasdf'
  ENV['MAILGUN_DOMAIN'] = 'testing.com'
  ENV['MAILGUN_DEFAULT_SENDER'] = 'noreply@testing.com'

  # Add more helper methods to be used by all tests here...
end
