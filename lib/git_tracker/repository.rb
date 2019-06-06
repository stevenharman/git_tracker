require "English"

module GitTracker
  module Repository
    def self.root
      path = `git rev-parse --show-toplevel`.chomp
      abort unless $CHILD_STATUS.exitstatus == 0
      path
    end

    def self.ensure_exists
      root
    end
  end
end
