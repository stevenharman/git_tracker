if ENV["CC_TEST_REPORTER_ID"]
  require "simplecov"
  SimpleCov.start
end

Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
end
