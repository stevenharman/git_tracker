require 'git_tracker/prepare_commit_message'

describe GitTracker::PrepareCommitMessage do

  describe '.run' do
    it "creates a new PrepareCommitMessage object" do
      GitTracker::PrepareCommitMessage.run("FILE1", "hook_source", "sha1234").
        should be_a(GitTracker::PrepareCommitMessage)
    end
  end

  describe ".new" do
    subject { GitTracker::PrepareCommitMessage }

    it "requires the name of the commit message file" do
      lambda { subject.new }.should raise_error(ArgumentError)
    end

    it "remembers the name of the commit message file" do
      subject.new("FILE1").file.should == "FILE1"
    end

    it "optionally accepts a message source" do
      hook = subject.new("FILE1", "merge").source.should == "merge"
    end

    it "optionally accepts the SHA-1 of a commit" do
      hook = subject.new("FILE1", "commit", "abc1234").commit_sha.should == "abc1234"
    end
  end

end
