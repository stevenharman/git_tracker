require "English"
require "git_tracker/repository"

module GitTracker
  module Branch
    def self.story_number
      current[/#?(\d{6,10})/, 1]
    end

    def self.current
      branch_path = `git symbolic-ref HEAD`

      Repository.ensure_exists unless exit_successful?

      branch_path[%r{refs/heads/(.+)}, 1] || ""
    end

    def self.exit_successful?
      $CHILD_STATUS.exitstatus == 0
    end

    private_class_method :exit_successful?
  end
end
