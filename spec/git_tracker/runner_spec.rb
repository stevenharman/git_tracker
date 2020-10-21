require "git_tracker/runner"

RSpec.describe GitTracker::Runner do
  subject(:runner) { described_class }
  let(:args) { ["a_file", "the_source", "sha1234"] }

  describe "::call" do
    include OutputHelper

    before do
      allow(runner).to receive(:prepare_commit_msg) { true }
    end

    it "runs the hook, passing the args" do
      expect(runner).to receive(:prepare_commit_msg).with(*args)
      runner.call("prepare-commit-msg", *args)
    end

    it "does not run hooks we do not know about" do
      errors = capture_stderr {
        expect { runner.call("non-existent-hook", *args) }.to_not succeed
      }
      expect(errors.chomp).to eq("[git_tracker] command: 'non-existent-hook' does not exist.")
    end
  end

  describe ".prepare_commit_msg" do
    it "runs the hook, passing the args" do
      expect(GitTracker::PrepareCommitMessage).to receive(:call).with(*args)
      runner.prepare_commit_msg(*args)
    end
  end

  describe ".init" do
    let(:repo_root) { "/path/to/git/repo/root" }

    it "tells the hook to initialize itself" do
      allow(GitTracker::Repository).to receive(:root) { repo_root }
      expect(GitTracker::Hook).to receive(:init).with(at: repo_root)
      runner.init
    end
  end

  it ".help reports that it was run" do
    expect(runner).to receive(:puts).with(/git-tracker #{GitTracker::VERSION} is installed\./)
    runner.call("help")
  end
end
