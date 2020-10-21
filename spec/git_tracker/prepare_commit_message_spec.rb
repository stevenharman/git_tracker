require "git_tracker/prepare_commit_message"

RSpec.describe GitTracker::PrepareCommitMessage do
  describe "initialization" do
    it "requires the name of the commit message file" do
      expect { described_class.new }.to raise_error(ArgumentError)
    end

    it "remembers the name of the commit message file" do
      expect(described_class.new("FILE1").file).to eq("FILE1")
    end

    it "optionally accepts a message source" do
      hook = described_class.new("FILE1", "merge").source

      expect(hook).to eq("merge")
    end

    it "optionally accepts the SHA-1 of a commit" do
      hook = described_class.new("FILE1", "commit", "abc1234").commit_sha

      expect(hook).to eq("abc1234")
    end
  end

  describe "#call" do
    let(:hook) { GitTracker::PrepareCommitMessage.new("FILE1") }
    let(:commit_message) { double("CommitMessage", append: nil) }

    before do
      allow(GitTracker::Branch).to receive(:story_number) { story }
      allow(GitTracker::CommitMessage).to receive(:new) { commit_message }
    end

    context "with an existing commit (via `-c`, `-C`, or `--amend` options)" do
      let(:hook) { described_class.new("FILE2", "commit", "60a086f3") }

      it "exits with status code 0" do
        expect { hook.call }.to succeed
      end
    end

    context "branch name without a Pivotal Tracker story number" do
      let(:story) { nil }

      it "exits without updating the commit message" do
        expect { hook.call }.to succeed
        expect(commit_message).to_not have_received(:append)
      end
    end

    context "branch name with a Pivotal Tracker story number" do
      let(:story) { "8675309" }
      before do
        allow(commit_message).to receive(:mentions_story?) { false }
        allow(commit_message).to receive(:keyword) { nil }
      end

      it "appends the number to the commit message" do
        hook.call
        expect(commit_message).to have_received(:append).with("[#8675309]")
      end

      context "keyword mentioned in the commit message" do
        before do
          allow(commit_message).to receive(:keyword) { "Delivers" }
        end

        it "appends the keyword and the story number" do
          hook.call
          expect(commit_message).to have_received(:append).with("[Delivers #8675309]")
        end
      end

      context "number already mentioned in the commit message" do
        before do
          allow(commit_message).to receive(:mentions_story?).with("8675309") { true }
        end

        it "exits without updating the commit message" do
          expect { hook.call }.to succeed
          expect(commit_message).to_not have_received(:append)
        end
      end
    end
  end
end
