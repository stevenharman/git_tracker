require "git_tracker/runner"

RSpec.describe GitTracker::Runner do
  subject(:runner) { described_class }

  describe "::call" do
    include OutputHelper
    let(:args) { ["a_file", "the_source", "sha1234"] }
    let(:io) { StringIO.new }

    it "runs the hook, passing the args" do
      expect(GitTracker::PrepareCommitMessage).to receive(:call).with(*args)
      runner.call("prepare-commit-msg", *args)
    end

    it "does not run hooks we do not know about" do
      errors = capture_stderr {
        expect { runner.call("non-existent-hook", *args) }.to_not succeed
      }
      expect(errors.chomp).to eq("[git_tracker] command: 'non-existent-hook' does not exist.")
    end

    it "shows the help/banner for the --help option" do
      runner.call("--help", io: io)

      expect(io.string).to match(/git-tracker is a Git hook used/)
    end

    it "shows the version for the --version option" do
      runner.call("--version", io: io)

      expect(io.string).to match(/git-tracker #{GitTracker::VERSION}/)
    end

    it "tells the hook to initialize itself" do
      repo_root = "/path/to/git/repo/root"
      allow(GitTracker::Repository).to receive(:root) { repo_root }

      expect(GitTracker::Hook).to receive(:init).with(at: repo_root)

      runner.call("init")
    end

    it "warns of deprecated install command" do
      allow(GitTracker::Hook).to receive(:init)

      warnings = capture_stderr {
        runner.call("install")
      }

      aggregate_failures do
        expect(warnings.chomp).to match(/git-tracker install.*deprecated.*git-tracker init/)
        expect(GitTracker::Hook).to have_received(:init)
      end
    end
  end
end
