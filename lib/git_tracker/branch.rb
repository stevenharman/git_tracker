require 'English'

module GitTracker
  module Branch
    def self.story_number
      current[/#(?<number>\d+)/, :number]
    end

    def self.current
      branch_path = `git symbolic-ref HEAD`

      abort unless $CHILD_STATUS.exitstatus == 0

      branch_path[%r{refs/heads/(?<name>.+)}, :name] || ''
    end
  end
end
