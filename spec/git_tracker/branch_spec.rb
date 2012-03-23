require 'git_tracker/branch'

describe GitTracker::Branch do
  subject { described_class }

  context "Current branch has a story number" do
    before do
      subject.stub('`') { 'refs/heads/a_very_descriptive_name_#8675309' }
    end

    it "shells out to git, looking for the current HEAD" do
      subject.story_number
      subject.should have_received('`').with('git symbolic-ref HEAD')
    end

    it "finds the story" do
      subject.story_number.should == '8675309'
    end
  end

  context "The current branch doesn't have a story number" do
    it "finds no story"
  end

  context "Not on a branch (HEAD doesn't exist)" do
    it "finds no story"
  end
end
