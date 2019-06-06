require "rspec/expectations"

RSpec::Matchers.define :succeed do
  actual = nil

  match do |block|
    begin
      block.call
    rescue SystemExit => e
      actual = e.status
    end
    actual && (actual == successful_exit_code)
  end

  failure_message do |block|
    "expected block to call exit(#{successful_exit_code}) but exit" +
      (actual.nil? ? " not called" : "(#{actual}) was called")
  end

  failure_message_when_negated do |block|
    "expected block not to call exit(#{successful_exit_code})"
  end

  description do
    "expect block to call exit(#{successful_exit_code})"
  end

  def successful_exit_code
    0
  end

  def supports_block_expectations?
    true
  end
end
