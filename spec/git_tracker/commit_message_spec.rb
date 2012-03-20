require 'git_tracker/commit_message'

describe GitTracker::CommitMessage do

  it "requires path to the temporary commit message file" do
    -> { GitTracker::CommitMessage.new }.should raise_error ArgumentError
  end

  describe "#contains?" do
    subject { described_class.new(commit_message_file) }
    let(:commit_message_file) { "COMMIT_EDITMSG" }
    before do
      File.stub(:read).with(commit_message_file) { EXAMPLE_COMMIT_EDITMSG }
    end

    context "commit message contains the special Pivotal Tracker story syntax" do
      it { subject.should be_contains("[#8675309]") }
    end
  end

  EXAMPLE_COMMIT_EDITMSG = <<-EXAMPLE
Got Jenny's number, gonna' make her mine!

[#8675309]
# Please enter the commit message for your changes. Lines starting
# with '#' will be ignored, and an empty message aborts the commit.
# On branch get_jennys_number_#8675309
# Changes to be committed:
#   (use "git reset HEAD <file>..." to unstage)
#
# new file:   fake_file.rb
#

EXAMPLE
end
