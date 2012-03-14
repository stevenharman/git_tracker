require 'git_tracker'

describe GitTracker do
  let(:args) { ["a_file", "the_source", "sha1234"] }

  describe ".execute" do
    before do
      GitTracker.stub(:prepare_commit_msg) { true }
    end

    it "runs the hook, passing the args" do
      GitTracker.execute('prepare-commit-msg', *args)
      GitTracker.should have_received(:prepare_commit_msg).with(*args)
    end

    # TODO: stop the abort from writing to stderr during tests?
    it "doesn't run hooks we don't know about" do
      lambda { GitTracker.execute('non-existent-hook', *args) }.
        should raise_error SystemExit, "git-tracker non-existent-hook does not exist."
    end
  end

  describe ".prepare_commit_msg" do
    before do
      GitTracker::PrepareCommitMessage.stub(:run) { true }
    end

    it "runs the hook, passing the args" do
      GitTracker.prepare_commit_msg(*args)
      GitTracker::PrepareCommitMessage.should have_received(:run).with(*args)
    end
  end

end
