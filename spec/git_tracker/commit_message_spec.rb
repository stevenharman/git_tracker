require 'git_tracker/commit_message'

describe GitTracker::CommitMessage do

  it "requires path to the temporary commit message file" do
    -> { GitTracker::CommitMessage.new }.should raise_error ArgumentError
  end

  describe "#contains?" do
    subject { described_class.new(file) }
    let(:file) { "COMMIT_EDITMSG" }
    before do
      File.stub(:read).with(file) { example_commit_message("[#8675309]") }
    end

    context "commit message contains the special Pivotal Tracker story syntax" do
      it { subject.should be_contains("[#8675309]") }
    end
  end

  def example_commit_message(pattern_to_match)
    return <<-EXAMPLE
Got Jenny's number, gonna' make her mine!

#{pattern_to_match}
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
end
