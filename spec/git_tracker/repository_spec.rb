require "git_tracker/repository"

RSpec.describe GitTracker::Repository do
  subject(:repository) { described_class }
  let(:git_command) { "git rev-parse --show-toplevel" }

  before do
    allow_message_expectations_on_nil
    allow(repository).to receive(:`).with(git_command) { "/path/to/git/repo/root\n" }
  end

  describe ".root" do
    it "gets the path to the top-level directory of the local Repository" do
      allow($?).to receive(:exitstatus) { 0 }
      expect(repository.root).to eq("/path/to/git/repo/root")
    end

    it "aborts when not in a git repository" do
      allow($?).to receive(:exitstatus) { 128 }
      expect { repository.root }.to_not succeed
    end
  end

  describe ".ensure_exists" do
    it "aborts when not in a git repository" do
      allow($?).to receive(:exitstatus) { 128 }
      expect { repository.root }.to_not succeed
    end
  end
end
