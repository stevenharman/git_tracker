#!/usr/bin/env rake
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)
task :default => :spec

file 'git-tracker' => FileList.new('lib/git_tracker.rb', 'lib/git_tracker/*.rb') do |task|
  $LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
  require 'git_tracker/standalone'
  GitTracker::Standalone.save(task.name)
end

desc 'Build standalone script'
task :standalone => 'git-tracker'

namespace :standalone do

  desc 'Install standalone script'
  task :install => :standalone do
    prefix = ENV['PREFIX'] || ENV['prefix'] || '/usr/local'

    FileUtils.mkdir_p "#{prefix}/bin"
    FileUtils.cp 'git-tracker', "#{prefix}/bin", :preserve => true
  end
end
