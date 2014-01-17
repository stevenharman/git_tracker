require 'spec_helper'
require 'git_tracker/runner'

describe GitTracker::Runner do
  subject(:runner) { described_class }
  let(:args) { ['a_file', 'the_source', 'sha1234'] }

  describe '.execute' do
    before do
      allow(runner).to receive(:prepare_commit_msg) { true }
    end

    it 'runs the hook, passing the args' do
      expect(runner).to receive(:prepare_commit_msg).with(*args) { true }
      runner.execute('prepare-commit-msg', *args)
    end

    # TODO: stop the abort from writing to stderr during tests?
    it 'does not run hooks we do not know about' do
      expect { runner.execute('non-existent-hook', *args) }.to_not succeed
    end
  end

  describe '.prepare_commit_msg' do
    it 'runs the hook, passing the args' do
      expect(GitTracker::PrepareCommitMessage).to receive(:run).with(*args) { true }
      runner.prepare_commit_msg(*args)
    end
  end

  describe '.init' do
    it 'tells the hook to initialize itself' do
      expect(GitTracker::Hook).to receive(:init)
      runner.init
    end
  end

  it '.help reports that it was run' do
    expect(runner).to receive(:puts).with(/git-tracker #{GitTracker::VERSION} is installed\./)
    runner.execute('help')
  end

end
