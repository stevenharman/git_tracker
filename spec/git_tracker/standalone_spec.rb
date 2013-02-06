require 'git_tracker/standalone'

describe GitTracker::Standalone do

  describe '#save' do
    before do
      File.delete 'git-tracker' if File.exists? 'git-tracker'
    end

    after do
      File.delete 'git-tracker' if File.exists? 'git-tracker'
    end

    it 'saves to the named file' do
      described_class.save('git-tracker')
      expect(File.size('./git-tracker')).to be > 100
    end

    it 'marks the binary as executable' do
      described_class.save('git-tracker')
      expect(File).to be_executable('./git-tracker')
    end
  end

  describe '#build' do
    subject { standalone }
    let(:io) { StringIO.new }
    let(:standalone) { described_class.build(io).string }

    it 'declares a shebang' do
      expect(subject).to match(/#!.+/)
    end

    it 'includes generated code notice' do
      expect(subject).to include('This file is generated')
    end

    it 'inlines the code' do
      expect(subject).to include('Hook')
      expect(subject).to include('Repository')
      expect(subject).to include('PrepareCommitMessage')
      expect(subject).to include('Runner')
      expect(subject).to include('Branch')
      expect(subject).to include('CommitMessage')
      expect(subject).to include('VERSION')
    end

    it 'inlines the message HEREDOC' do
      expect(standalone).to include('#{preamble.strip}')
    end

    it 'inlines the shebang for the hook' do
      expect(standalone).to include('#!/usr/bin/env bash')
    end

    it 'does not inline the standalone code' do
      expect(subject).to_not include('module Standalone')
    end

    it 'includes the call to execute the hook' do
      expect(subject).to include('GitTracker::Runner.execute(*ARGV)')
    end

    it 'excludes requiring git_tracker code' do
      expect(subject).to_not match(/^require\s+["']git_tracker/)
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
      expect(subject.ruby_executable).to eq('/usr/bin/ruby')
    end

    it 'uses rbconfig ruby when user-level ruby binary not executable' do
      File.stub(:executable?).with('/usr/bin/ruby') { false }
      expect(subject.ruby_executable).to eq('/some/other/bin/ruby')
    end
  end
end
