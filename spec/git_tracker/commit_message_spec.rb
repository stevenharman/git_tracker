require 'git_tracker/commit_message'
require 'commit_message_helper'

describe GitTracker::CommitMessage do
  include CommitMessageHelper

  it "requires path to the temporary commit message file" do
    -> { GitTracker::CommitMessage.new }.should raise_error ArgumentError
  end

  describe "#contains?" do
    subject { described_class.new(file) }
    let(:file) { "COMMIT_EDITMSG" }
    before do
      File.stub(:read).with(file) { commit_message_text }
    end

    context "commit message contains the special Pivotal Tracker story syntax" do
      let(:commit_message_text) { example_commit_message("[#8675309]") }
      it { subject.should be_contains("[#8675309]") }
    end

    context "commit message doesn't contain the special Pivotal Tracker story syntax" do
      let(:commit_message_text) { example_commit_message("[#not_it]") }
      it { subject.should_not be_contains("[#8675309]") }
    end
  end

end
