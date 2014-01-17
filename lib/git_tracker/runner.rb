require 'git_tracker/prepare_commit_message'
require 'git_tracker/hook'
require 'git_tracker/version'

module GitTracker
  module Runner

    def self.execute(cmd_arg = 'help', *args)
      command = cmd_arg.gsub(/-/, '_')
      abort("[git_tracker] command: '#{cmd_arg}' does not exist.") unless respond_to?(command)
      send(command, *args)
    end

    def self.prepare_commit_msg(*args)
      PrepareCommitMessage.run(*args)
    end

    def self.init
      Hook.init
    end

    def self.install
      puts "`git-tracker install` is deprecated. Please use `git-tracker init`"
      self.init
    end

    def self.help
      puts <<-HELP
git-tracker #{VERSION} is installed.

Remember, git-tracker is a hook which Git interacts with during its normal
lifecycle of committing, rebasing, merging, etc. You need to initialize this
hook by running `git-tracker init` from each repository in which you wish to
use it. Cheers!
      HELP
    end
  end

end
