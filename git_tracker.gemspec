# -*- encoding: utf-8 -*-
require File.expand_path('../lib/git_tracker/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'git_tracker'
  gem.version       = GitTracker::VERSION
  gem.authors       = ['Steven Harman']
  gem.email         = ['steven@harmanly.com']
  gem.homepage      = 'https://github.com/stevenharman/git_tracker'
  gem.summary       = %q{Teaching Git about Pivotal Tracker.}
  gem.description   = <<-EOF
    Some simple tricks that make working with Pivotal Tracker even
    better... and easier... um, besier!
  EOF

  gem.add_development_dependency 'rspec', '~> 3.2.0'
  gem.add_development_dependency 'activesupport', '~> 3.2'
  # Use i18n < 0.7 until we drop Ruby 1.8.7 and 1.9.2 support
  gem.add_development_dependency 'i18n', '~> 0.6.11'
  gem.add_development_dependency 'pry', '~> 0.10.1'
  # Use Rake < 10.2 (requires Ruby 1.9+) until we drop Ruby 1.8.7 support
  gem.add_development_dependency 'rake', '~> 10.1.1'
  # Use json < 2.0 (requires Ruby 2.0+) until we drop Ruby < 2.0 support
  gem.add_development_dependency "json", "< 2" if RUBY_VERSION < "2"

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables   = %w(git-tracker)
  gem.platform      = Gem::Platform::RUBY
  gem.require_paths = ['lib']
  gem.required_ruby_version = '>= 1.9.3'
end
