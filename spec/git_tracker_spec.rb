require 'spec_helper'
require 'git_tracker'

describe GitTracker do
  subject { described_class }
  let(:args) { ['a_file', 'the_source', 'sha1234'] }

  describe '.execute' do
    before do
      subject.stub(:prepare_commit_msg) { true }
    end

    it 'runs the hook, passing the args' do
      subject.should_receive(:prepare_commit_msg).with(*args) { true }
      subject.execute('prepare-commit-msg', *args)
    end

    # TODO: stop the abort from writing to stderr during tests?
    it 'does not run hooks we do not know about' do
      lambda { subject.execute('non-existent-hook', *args) }.should_not succeed
    end
  end

  describe '.prepare_commit_msg' do
    it 'runs the hook, passing the args' do
      GitTracker::PrepareCommitMessage.should_receive(:run).with(*args) { true }
      subject.prepare_commit_msg(*args)
    end
  end

  describe '.install' do
    it 'tells the hook to install itself' do
      GitTracker::Hook.should_receive(:install)
      subject.install
    end
  end

end
