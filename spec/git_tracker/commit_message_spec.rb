require 'git_tracker/commit_message'
require 'commit_message_helper'

describe GitTracker::CommitMessage do
  include CommitMessageHelper

  it "requires path to the temporary commit message file" do
    -> { GitTracker::CommitMessage.new }.should raise_error ArgumentError
  end

  describe "#mentions_story?" do
    subject { described_class.new(file) }
    let(:file) { "COMMIT_EDITMSG" }

    def stub_commit_message(story_text)
      File.stub(:read).with(file) { example_commit_message(story_text) }
    end

    context "commit message contains the special Pivotal Tracker story syntax" do
      it "matches just the number" do
        stub_commit_message("[#8675309]")
        subject.should be_mentions_story("8675309")
      end

      it "matches state change and number" do
        stub_commit_message("[Fixes #8675309]")
        subject.should be_mentions_story("8675309")
      end
    end

    context "commit message doesn't contain the special Pivotal Tracker story syntax" do
      it "doesn't match without brackets" do
        stub_commit_message("#8675309")
        subject.should_not be_mentions_story("8675309")
      end
    end
  end

end
