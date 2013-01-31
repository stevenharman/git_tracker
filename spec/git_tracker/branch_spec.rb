require 'spec_helper'
require 'git_tracker/branch'

describe GitTracker::Branch do
  subject { described_class }

  def stub_branch(ref, exit_status = 0)
    allow_message_expectations_on_nil
    subject.stub(:`) { ref }
    $?.stub(:exitstatus) { exit_status }
  end

  describe '.current' do
    it 'shells out to git, looking for the current HEAD' do
      stub_branch('refs/heads/herpty_derp_de')
      subject.should_receive('`').with('git symbolic-ref HEAD')
      subject.current
    end

    it 'ensures in a Git repository when looking for HEAD exits with non-zero status' do
      stub_branch('', 128)

      GitTracker::Repository.should_receive(:ensure_exists)
      subject.current
    end
  end

  describe '.story_number' do
    context 'Current branch has a story number' do
      it 'finds the story that starts with a hash' do
        stub_branch('refs/heads/a_very_descriptive_name_#8675309')
        subject.story_number.should == '8675309'
      end

      it 'finds the story without a leading hash' do
        stub_branch('refs/heads/a_very_descriptive_name_1235309')
        subject.story_number.should == '1235309'
      end

      it 'finds the story following a forward hash' do
        stub_branch('refs/heads/alindeman/8675309_got_her_number')
        subject.story_number.should == '8675309'
      end

      it 'finds the story in a branch with hyphens' do
        stub_branch('refs/heads/stevenharman/got-her-number-8675309')
        expect(subject.story_number).to eq('8675309')
      end
    end

    context 'The current branch does not have a story number' do
      it 'finds no story' do
        stub_branch('refs/heads/a_very_descriptive_name-without_a_#number')
        subject.story_number.should_not be
      end
    end

    context 'Not on a branch (HEAD does not exist)' do
      it 'finds no story' do
        stub_branch('')
        subject.story_number.should_not be
      end
    end
  end
end
