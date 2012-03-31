require 'english'

module GitTracker
  module Repository

    def self.root
      path = `git rev-parse --show-toplevel`.chomp
      abort unless $CHILD_STATUS.exitstatus == 0
      path
    end

  end
end
