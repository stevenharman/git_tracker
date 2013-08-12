require 'git_tracker/prepare_commit_message'
require 'git_tracker/hook'

module GitTracker
  module Runner

    def self.execute(cmd_arg, *args)
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

    def self.test_command
      puts "git-tracker #{VERSION} is here. How are you?"
    end
  end

end
