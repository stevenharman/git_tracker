require 'git_tracker/standalone'

describe GitTracker::Standalone do
  subject { standalone }
  let(:io) { StringIO.new }
  let(:standalone) { described_class.build(io).string }

  describe '#build' do
    it 'declares a shebang' do
      subject.should =~ /#!.+/
    end

    it 'includes generated code notice' do
      subject.should include('This file is generated')
    end

    it 'inlines the code' do
      subject.should include('Hook')
      subject.should include('Repository')
      subject.should include('PrepareCommitMessage')
      subject.should include('Runner')
      subject.should include('Branch')
      subject.should include('CommitMessage')
      subject.should include('VERSION')
    end

    it 'does not inline the standalone code' do
      subject.should_not include('module Standalone')
    end

    it 'includes the call to execute the hook' do
      subject.should include('GitTracker::Runner.execute(*ARGV)')
    end

    it 'excludes requiring git_tracker code' do
      subject.should_not =~ /^require\s+["']git_tracker/
    end
  end

  describe '#ruby_executable' do
    subject { described_class }
    before do
      RbConfig::CONFIG.stub(:[]).with('bindir') { '/some/other/bin' }
      RbConfig::CONFIG.stub(:[]).with('ruby_install_name') { 'ruby' }
    end

    it 'uses user-level ruby binary when it is executable' do
      File.stub(:executable?).with('/usr/bin/ruby') { true }
      subject.ruby_executable.should == '/usr/bin/ruby'
    end

    it 'uses rbconfig ruby when user-level ruby binary not executable' do
      File.stub(:executable?).with('/usr/bin/ruby') { false }
      subject.ruby_executable.should == '/some/other/bin/ruby'
    end
  end
end
