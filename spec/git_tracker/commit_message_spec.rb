require 'git_tracker/commit_message'

describe GitTracker::CommitMessage do

  it "requires path to the temporary commit message file" do
    -> { GitTracker::CommitMessage.new }.should raise_error ArgumentError
  end

end
