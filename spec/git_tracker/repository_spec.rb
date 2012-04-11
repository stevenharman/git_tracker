require 'spec_helper'
require 'git_tracker/repository'

describe GitTracker::Repository do
  subject { described_class }

  describe '.root' do
    let(:git_command) { 'git rev-parse --show-toplevel' }
    before do
      allow_message_expectations_on_nil
      subject.stub(:`).with(git_command) { "/path/to/git/repo/root\n" }
      $?.stub(:exitstatus) { 0 }
    end

    it "gets the path to the local Repository's top-level directory" do
      subject.root.should == '/path/to/git/repo/root'
    end

    it 'aborts when not in a git repository' do
      $?.stub(:exitstatus) { 128 }
      lambda { subject.root }.should_not succeed
    end
  end

end
