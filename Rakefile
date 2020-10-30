#!/usr/bin/env rake

require Pathname(".").join("lib/git_tracker/version").expand_path

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
directory "pkg"

file "pkg/git-tracker" => Rake::FileList.new("pkg", "lib/git_tracker.rb", "lib/git_tracker/*.rb") do |task|
  $LOAD_PATH.unshift(Pathname(__dir__).join("lib").expand_path)
  require "git_tracker/standalone"

  path, filename = task.name.split("/")
  GitTracker::Standalone.save(filename, path: path)
end

namespace :standalone do
  desc "Build standalone script"
  task build: "pkg/git-tracker"

  desc "Build and install standalone script"
  task install: "standalone:build" do
    prefix = ENV["PREFIX"] || ENV["prefix"] || "/usr/local"

    FileUtils.mkdir_p("#{prefix}/bin")
    FileUtils.cp("pkg/git-tracker", "#{prefix}/bin", preserve: true)
  end

  task :homebrew do
    archive_url = "https://github.com/stevenharman/git_tracker/archive/v#{GitTracker::VERSION}.tar.gz"
    Bundler.with_clean_env do
      sh "brew bump-formula-pr git-tracker --url=#{archive_url}"
    end
  end
end
