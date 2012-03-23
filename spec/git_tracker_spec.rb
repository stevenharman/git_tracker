require 'git_tracker'

describe GitTracker do
  subject { described_class }
  let(:args) { ["a_file", "the_source", "sha1234"] }

  describe ".execute" do
    before do
      subject.stub(:prepare_commit_msg) { true }
    end

    it "runs the hook, passing the args" do
      subject.should_receive(:prepare_commit_msg).with(*args) { true }
      subject.execute('prepare-commit-msg', *args)
    end

    # TODO: stop the abort from writing to stderr during tests?
    it "doesn't run hooks we don't know about" do
      lambda { subject.execute('non-existent-hook', *args) }.
        should raise_error SystemExit, "[git_tracker] hook: 'non-existent-hook' does not exist."
    end
  end

  describe ".prepare_commit_msg" do
    it "runs the hook, passing the args" do
      GitTracker::PrepareCommitMessage.should_receive(:run).with(*args) { true }
      subject.prepare_commit_msg(*args)
    end
  end

end
