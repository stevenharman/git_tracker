require 'git_tracker/prepare_commit_message'

describe GitTracker::PrepareCommitMessage do

  describe '.run' do
    it "creates a new PrepareCommitMessage object" do
      GitTracker::PrepareCommitMessage.run("FILE1", "hook_source", "sha1234").
        should be_a(GitTracker::PrepareCommitMessage)
    end
  end

end
