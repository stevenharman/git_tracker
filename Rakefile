#!/usr/bin/env rake
require 'rspec/core/rake_task'
require File.expand_path('../lib/git_tracker/version', __FILE__)

RSpec::Core::RakeTask.new(:spec)
task :default => :spec

namespace :gem do
  require 'bundler/gem_tasks'
end

file 'git-tracker' => FileList.new('lib/git_tracker.rb', 'lib/git_tracker/*.rb') do |task|
  $LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
  require 'git_tracker/standalone'
  GitTracker::Standalone.save(task.name)
end

namespace :standalone do

  desc 'Build standalone script'
  task :build => 'git-tracker'

  desc 'Build and install standalone script'
  task :install => 'standalone:build' do
    prefix = ENV['PREFIX'] || ENV['prefix'] || '/usr/local'

    FileUtils.mkdir_p "#{prefix}/bin"
    FileUtils.cp 'git-tracker', "#{prefix}/bin", :preserve => true
  end

  task :homebrew do
    Dir.chdir `brew --prefix`.chomp do
      sh 'git checkout -q origin'
      sh 'git pull -q origin master'

      formula_file = 'Library/Formula/git-tracker.rb'
      sha = `curl -#L https://github.com/stevenharman/git_tracker/tarball/v#{GitTracker::VERSION} | shasum`.split(/\s+/).first
      abort unless $?.success? and sha.length == 40

      formula = File.read formula_file
      formula.sub! /\bv\d+(\.\d+)*/, "v#{GitTracker::VERSION}"
      formula.sub! /\b[0-9a-f]{40}\b/, sha
      File.open(formula_file, 'w') {|f| f << formula }

      branch = "git_tracker-v#{GitTracker::VERSION}"
      sh "git checkout -q -B #{branch}"
      sh "git commit -m 'upgrade git-tracker to v#{GitTracker::VERSION}' -- #{formula_file}"
      sh "git push -u stevenharman #{branch}"
      sh "hub pull-request 'upgrade git-tracker to v#{GitTracker::VERSION}'"

      sh "git checkout -q master"
    end
  end
end

desc "Create tag v#{GitTracker::VERSION}, build, and push to GitHub, Rubygems, and Homebrew"
task :release => ['gem:release', 'standalone:homebrew']
