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

  gem.add_development_dependency 'rspec', '~> 3.5'
  gem.add_development_dependency 'pry', '~> 0.10'
  gem.add_development_dependency 'rake', '~> 12.0'

  if RUBY_VERSION >= '2.2.2'
    gem.add_development_dependency 'activesupport', '~> 5.0'
  else
    gem.add_development_dependency 'activesupport', '~> 4.0'
  end

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables   = %w(git-tracker)
  gem.platform      = Gem::Platform::RUBY
  gem.require_paths = ['lib']
  gem.required_ruby_version = '>= 2.1.0'
end
