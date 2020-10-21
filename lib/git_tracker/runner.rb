require "git_tracker/prepare_commit_message"
require "git_tracker/hook"
require "git_tracker/repository"
require "git_tracker/version"

module GitTracker
  module Runner
    def self.call(cmd_arg = "help", *args)
      command = cmd_arg.tr("-", "_")

      abort("[git_tracker] command: '#{cmd_arg}' does not exist.") unless respond_to?(command)

      send(command, *args)
    end

    def self.prepare_commit_msg(*args)
      PrepareCommitMessage.call(*args)
    end

    def self.init
      Hook.init(at: Repository.root)
    end

    def self.install
      warn("`git-tracker install` is deprecated. Please use `git-tracker init`", uplevel: 1)

      init
    end

    def self.help
      puts <<~HELP
        git-tracker #{VERSION} is installed.

        Remember, git-tracker is a hook which Git interacts with during its normal
        lifecycle of committing, rebasing, merging, etc. You need to initialize this
        hook by running `git-tracker init` from each repository in which you wish to
        use it. Cheers!
      HELP
    end
  end
end
