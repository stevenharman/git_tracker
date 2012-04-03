require 'git_tracker/branch'

describe GitTracker::Branch do
  subject { described_class }

  def stub_branch(ref, exit_status = 0)
    subject.stub(:`) { ref }
    $?.stub(:exitstatus) { exit_status }
  end

  context 'not in a Git repository' do
    it 'aborts with non-zero exit status' do
      stub_branch(nil, 128)

      -> { subject.current }.should raise_error SystemExit
    end
  end

  context "Current branch has a story number" do
    before do
      stub_branch('refs/heads/a_very_descriptive_name_#8675309')
    end

    it "shells out to git, looking for the current HEAD" do
      subject.should_receive('`').with('git symbolic-ref HEAD')
      subject.story_number
    end

    it "finds the story" do
      subject.story_number.should == '8675309'
    end
  end

  context "The current branch doesn't have a story number" do
    it "finds no story" do
      stub_branch('refs/heads/a_very_descriptive_name_without_a_#number')
      subject.story_number.should_not be
    end
  end

  context "Not on a branch (HEAD doesn't exist)" do
    it "finds no story" do
      stub_branch('')
      subject.story_number.should_not be
    end
  end
end
