require File.expand_path("../lib/git_tracker/version", __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "git_tracker"
  spec.version       = GitTracker::VERSION
  spec.authors       = ["Steven Harman"]
  spec.email         = ["steven@harmanly.com"]
  spec.homepage      = "https://github.com/stevenharman/git_tracker"
  spec.summary       = "Teaching Git about Pivotal Tracker."
  spec.description   = <<-EOF
    Some simple tricks that make working with Pivotal Tracker even
    better... and easier... um, besier!
  EOF

  spec.add_development_dependency "rspec", "~> 3.5"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "simplecov", "~> 0.16"

  if RUBY_VERSION >= "2.2.2"
    spec.add_development_dependency "activesupport", "~> 5.0"
  else
    spec.add_development_dependency "activesupport", "~> 4.0"
  end

  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables   = %w[git-tracker]
  spec.platform      = Gem::Platform::RUBY
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.1.0"
end
