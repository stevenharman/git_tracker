if ENV["CC_TEST_REPORTER_ID"]
  require "simplecov"
  SimpleCov.start
end

require_relative "support/commit_message_helper"
require_relative "support/fake_file"
require_relative "support/output_helper"
require_relative "support/matchers/exit_code_matchers"

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
end
