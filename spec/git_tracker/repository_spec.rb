require 'git_tracker/repository'

describe GitTracker::Repository do
  subject { described_class }

  describe '.root' do
    let(:git_command) { 'git rev-parse --show-toplevel' }
    before do
      subject.stub(:`).with(git_command) { "/path/to/git/repo/root\n" }
    end

    it "gets the path to the local Repository's top-level directory" do
      subject.root.should == '/path/to/git/repo/root'
    end

    it 'aborts when not in a git repository' do
      $?.stub(:exitstatus) { 128 }
      -> { subject.root }.should raise_error SystemExit
    end
  end

end
