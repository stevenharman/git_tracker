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
      it "allows just the number" do
        stub_commit_message("[#8675309]")
        subject.should be_mentions_story("8675309")
      end

      it "allows multiple numbers" do
        stub_commit_message("[#99 #777 #8675309 #111222]")
        subject.should be_mentions_story("99")
        subject.should be_mentions_story("777")
        subject.should be_mentions_story("8675309")
        subject.should be_mentions_story("111222")
      end

      it "allows state change before number" do
        stub_commit_message("[Fixes #8675309]")
        subject.should be_mentions_story("8675309")
      end

      it "allows state change after the number" do
        stub_commit_message("[#8675309 Delivered]")
        subject.should be_mentions_story("8675309")
      end

      it "allows surrounding text" do
        stub_commit_message("derp de herp [Fixes #8675309] de herp-ity derp")
        subject.should be_mentions_story("8675309")
      end
    end

    context "commit message doesn't contain the special Pivotal Tracker story syntax" do
      it "requires brackets" do
        stub_commit_message("#8675309")
        subject.should_not be_mentions_story("8675309")
      end

      it "requires a pound sign" do
        stub_commit_message("[8675309]")
        subject.should_not be_mentions_story("8675309")
      end

      it "doesn't allow the bare number" do
        stub_commit_message("8675309")
        subject.should_not be_mentions_story("8675309")
      end

      it "doesn't allow multiple state changes" do
        stub_commit_message("[#Fixes Deploys #8675309]")
        subject.should_not be_mentions_story("8675309")
      end
    end
  end

end
