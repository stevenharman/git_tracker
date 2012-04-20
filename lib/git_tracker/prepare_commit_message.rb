require 'git_tracker/branch'
require 'git_tracker/commit_message'

module GitTracker
  class PrepareCommitMessage
    attr_reader :file, :source, :commit_sha

    def self.run(file, source=nil, commit_sha=nil)
      new(file, source, commit_sha).run
    end

    def initialize(file, source=nil, commit_sha=nil)
      @file = file
      @source = source
      @commit_sha = commit_sha
    end

    def run
      exit_when_commit_exists

      story = story_number_from_branch
      message = CommitMessage.new(file)
      exit if message.mentions_story?(story)
      keyword = message.keyword

      message_addition = [keyword, "##{story}"].compact.join(' ')
      message.append("[#{message_addition}]")
    end

    private

    def exit_when_commit_exists
      exit if source == 'commit'
    end

    def story_number_from_branch
      story = Branch.story_number
      exit unless story
      story
    end
  end
end
