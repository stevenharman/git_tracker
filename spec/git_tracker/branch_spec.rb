require 'spec_helper'
require 'git_tracker/branch'

describe GitTracker::Branch do
  subject(:branch) { described_class }

  def stub_branch(ref, exit_status = 0)
    allow_message_expectations_on_nil
    allow(branch).to receive(:`) { ref }
    allow($?).to receive(:exitstatus) { exit_status }
  end

  describe '.current' do
    it 'shells out to git, looking for the current HEAD' do
      stub_branch('refs/heads/herpty_derp_de')
      expect(branch).to receive('`').with('git symbolic-ref HEAD')
      branch.current
    end

    it 'ensures in a Git repository when looking for HEAD exits with non-zero status' do
      stub_branch('', 128)

      expect(GitTracker::Repository).to receive(:ensure_exists)
      branch.current
    end
  end

  describe '.story_number' do
    context 'Current branch has a story number' do
      it 'finds the story that starts with a hash' do
        stub_branch('refs/heads/a_very_descriptive_name_#8675309')
        expect(branch.story_number).to eq('8675309')
      end

      it 'finds the story without a leading hash' do
        stub_branch('refs/heads/a_very_descriptive_name_1235309')
        expect(branch.story_number).to eq('1235309')
      end

      it 'finds the story following a forward hash' do
        stub_branch('refs/heads/alindeman/8675309_got_her_number')
        expect(branch.story_number).to eq('8675309')
      end

      it 'finds the story in a branch with hyphens' do
        stub_branch('refs/heads/stevenharman/got-her-number-8675309')
        expect(branch.story_number).to eq('8675309')
      end
      
      it 'finds the story in a branch with a version number' do
        stub_branch('refs/heads/stevenharman/v2.0-got-her-number-8675309')
        expect(branch.story_number).to eq('8675309')
      end
    end

    context 'The current branch has a number that is not a story' do
      it 'finds no story' do
        stub_branch('refs/heads/a_very_descriptive_name_with_some_a_version_number_v2.0')
        expect(branch.story_number).to_not be
      end
    end

    context 'The current branch does not have a story number' do
      it 'finds no story' do
        stub_branch('refs/heads/a_very_descriptive_name-without_a_#number')
        expect(branch.story_number).to_not be
      end
    end

    context 'Not on a branch (HEAD does not exist)' do
      it 'finds no story' do
        stub_branch('')
        expect(branch.story_number).to_not be
      end
    end
  end
end
