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

  gem.add_development_dependency 'rspec', '~> 2.14'
  gem.add_development_dependency 'activesupport', '~> 4.0'
  gem.add_development_dependency 'pry', '~> 0.9.11'
  # Use Rake < 10.2 (requires Ruby 1.9+) until we drop Ruby 1.8.7 support
  gem.add_development_dependency 'rake', '~> 10.1.1'

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables   = %w(git-tracker)
  gem.require_paths = ['lib']
end
