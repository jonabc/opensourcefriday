ENV["RAILS_ENV"] ||= "test"

require "simplecov"

SimpleCov.start("rails") do
  add_filter "/Rakefile"
  add_filter "/bin/"
  add_filter "/test/"
  add_filter "/vendor/"
  minimum_coverage 60
end

SimpleCov.formatters = [SimpleCov::Formatter::HTMLFormatter]

require File.expand_path("../config/environment", __dir__)
require "rails/test_help"

require "vcr"
VCR.configure do |config|
  config.cassette_library_dir = "test/vcr_cassettes"
  config.hook_into :faraday
  config.default_cassette_options = {
    record: ENV["CI"] ? :none : :once,
    match_requests_on: %i[host path],
  }
  config.before_record { |i| i.request.headers.delete "Authorization" }
end
Octokit.middleware = Faraday::RackBuilder.new

OmniAuth.config.test_mode = true
OmniAuth.config.logger = Rails.logger

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
