module GitTracker
  module Branch
    def self.story_number
      current[/#(?<number>\d+)/, :number]
    end

    def self.current
      branch_path = `git symbolic-ref HEAD`
      branch_path[%r{refs/heads/(?<name>.+)}, :name] || ''
    end
  end
end
