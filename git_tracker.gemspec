# -*- encoding: utf-8 -*-
require File.expand_path('../lib/git_tracker/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "git_tracker"
  gem.version       = GitTracker::VERSION
  gem.authors       = ["Steven Harman"]
  gem.email         = ["steveharman@gmail.com"]
  gem.homepage      = "https://github.com/stevenharman/git_tracker"
  gem.summary       = %q{Teaching Git about Pivotal Tracker.}
  gem.description   = <<-EOF
    Some simple tricks that make working with Pivotal Tracker even
    better... and easier... um, besier!
  EOF

  gem.add_development_dependency "rspec", "~> 2.12"
  gem.add_development_dependency "rspec-spies", "~> 2.0"
  gem.add_development_dependency "activesupport", "~> 3.2"
  gem.add_development_dependency "rake"

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables   = %w(git-tracker)
  gem.require_paths = ["lib"]
end
