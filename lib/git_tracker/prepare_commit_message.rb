require 'git_tracker/branch'
require 'git_tracker/commit_message'

module GitTracker
  class PrepareCommitMessage
    attr_reader :file, :source, :commit_sha

    def self.run(file, source=nil, commit_sha=nil)
      new(file, source, commit_sha)
    end

    def initialize(file, source=nil, commit_sha=nil)
      @file = file
      @source = source
      @commit_sha = commit_sha
    end

    def run
      story = Branch.story_number
      exit unless story
    end
  end
end
