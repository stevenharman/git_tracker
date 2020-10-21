require File.expand_path("../lib/git_tracker/version", __FILE__)

Gem::Specification.new do |spec|
  spec.name = "git_tracker"
  spec.version = GitTracker::VERSION
  spec.authors = ["Steven Harman"]
  spec.email = ["steven@harmanly.com"]

  spec.summary = "Teaching Git about Pivotal Tracker."
  spec.description = <<~EOF
    Some simple tricks that make working with Pivotal Tracker even
    better... and easier... um, besier!
  EOF
  spec.homepage = "https://github.com/stevenharman/git_tracker"
  spec.license = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  spec.metadata = {
    "homepage_uri" => spec.homepage,
    "source_code_uri" => spec.homepage,
    "bug_tracker_uri" => "#{spec.homepage}/issues",
    "changelog_uri" => "#{spec.homepage}/blob/master/CHANGELOG.md"
  }

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path("..", __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(\.gitignore|\.rspec|\.travis\.yml|bin/|spec/|features/)}) }
  end
  spec.bindir = "exe"
  spec.executables = %w[git-tracker]
  spec.require_paths = ["lib"]
  spec.platform = Gem::Platform::RUBY

  spec.add_development_dependency "pry-byebug", "~> 3.9"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.9"
  # Simplecov 0.18+ is currently broken for the cc-test-reporter.
  # Until it's fixed, we need to stick to something pre-0.18
  # see: https://github.com/codeclimate/test-reporter/issues/413
  spec.add_development_dependency "simplecov", "~> 0.17.0"
end
