require 'spec_helper'
require 'git_tracker/prepare_commit_message'

describe GitTracker::PrepareCommitMessage do
  subject { GitTracker::PrepareCommitMessage }

  describe '.run' do
    let(:hook) { stub("PrepareCommitMessage") }
    before do
      subject.stub(:new) { hook }
    end

    it "runs the hook" do
      hook.should_receive(:run)
      subject.run("FILE1", "hook_source", "sha1234")
    end
  end

  describe ".new" do

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

  describe '#run' do
    let(:hook) { GitTracker::PrepareCommitMessage.new("FILE1") }
    before do
      GitTracker::Branch.stub(:story_number) { story }
    end

    context 'with an existing commit (via `-c`, `-C`, or `--amend` options)' do
      let(:hook) { described_class.new('FILE2', 'commit', '60a086f3') }

      it 'exits with status code 0' do
        lambda { hook.run }.should succeed
      end
    end

    context "branch name without a Pivotal Tracker story number" do
      let(:story) { nil }

      it "exits without updating the commit message" do
        lambda { hook.run }.should raise_exception(SystemExit)
        GitTracker::CommitMessage.should_not have_received(:append)
      end
    end

    context "branch name with a Pivotal Tracker story number" do
      let(:story) { "8675309" }
      let(:commit_message) { stub("CommitMessage", mentions_story?: false) }
      before do
        GitTracker::CommitMessage.stub(:new) { commit_message }
      end

      it "appends the number to the commit message" do
        commit_message.should_receive(:append).with("[#8675309]")
        hook.run
      end

      context "number already mentioned in the commit message" do
        before do
          commit_message.stub(:mentions_story?).with("8675309") { true }
        end

        it "exits without updating the commit message" do
          lambda { hook.run }.should raise_exception(SystemExit)
          GitTracker::CommitMessage.should_not have_received(:append)
        end
      end
    end

  end
end
