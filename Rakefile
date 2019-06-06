#!/usr/bin/env rake
require File.expand_path("../lib/git_tracker/version", __FILE__)

# Skip these tasks when being installed by Homebrew
unless ENV["HOMEBREW_BREW_FILE"]

  require "rspec/core/rake_task"
  RSpec::Core::RakeTask.new(:spec)
  task default: :spec

  # Rubygems tasks
  namespace :gem do
    require "bundler/gem_tasks"
  end

  desc "Create tag v#{GitTracker::VERSION}, build, and push to GitHub, Rubygems, and Homebrew"
  task release: ["gem:release", "standalone:homebrew"]

end

# standalone and Homebrew
file "git-tracker" => FileList.new("lib/git_tracker.rb", "lib/git_tracker/*.rb") do |task|
  $LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
  require "git_tracker/standalone"
  GitTracker::Standalone.save(task.name)
end

namespace :standalone do
  desc "Build standalone script"
  task build: "git-tracker"

  desc "Build and install standalone script"
  task install: "standalone:build" do
    prefix = ENV["PREFIX"] || ENV["prefix"] || "/usr/local"

    FileUtils.mkdir_p "#{prefix}/bin"
    FileUtils.cp "git-tracker", "#{prefix}/bin", preserve: true
  end

  task :homebrew do
    archive_url = "https://github.com/stevenharman/git_tracker/archive/v#{GitTracker::VERSION}.tar.gz"
    Bundler.with_clean_env do
      sh "brew bump-formula-pr git-tracker --url=#{archive_url}"
    end
  end
end
