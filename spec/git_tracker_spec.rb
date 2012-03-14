require 'git_tracker'

describe GitTracker do

  describe ".execute" do
    let(:args) { ["file", "source", "sha1"] }
    before do
      GitTracker.stub(:prepare_commit_msg) { true }
    end

    it "runs the hook, passing the args" do
      GitTracker.execute('prepare-commit-msg', *args)
      GitTracker.should have_received(:prepare_commit_msg).with(*args)
    end

    it "doesn't run hooks we don't know about" do
      GitTracker.execute('non-existent-hook', *args)
      GitTracker.should_not have_received(:non_existent_hook)
    end
  end

end
