require 'English'
require 'git_tracker/repository'

module GitTracker
  module Branch
    def self.story_number
      current[/#?(?<number>\d+)/, :number]
    end

    def self.current
      branch_path = `git symbolic-ref HEAD`

      Repository.ensure_exists unless exit_successful?

      branch_path[%r{refs/heads/(?<name>.+)}, :name] || ''
    end

    private

    def self.exit_successful?
      $CHILD_STATUS.exitstatus == 0
    end
  end
end
