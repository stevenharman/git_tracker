require 'spec_helper'
require 'git_tracker/hook'
require 'active_support/core_ext/string/strip'

describe GitTracker::Hook do
  subject { described_class }
  let(:root) { '/path/to/git/repo/toplevel' }
  let(:hook_path) { File.join(root, '.git', 'hooks', 'prepare-commit-msg') }

  describe '.install' do
    before do
      GitTracker::Repository.stub(:root) { root }
    end

    it 'installs to the root of the Git repository' do
      subject.should_receive(:install_at).with(root)
      subject.install
    end
  end

  describe '.install_at' do
    let(:fake_file) { GitTracker::FakeFile.new }
    before do
      File.stub(:open).and_yield(fake_file)
    end

    it 'writes the hook into the hooks directory' do
      File.should_receive(:open).with(hook_path, 'w')
      subject.install_at(root)
    end

    it 'makes the hook executable' do
      subject.install_at(root)
      fake_file.mode.should == 0755
    end

    it 'writes the hook code in the hook file' do
      subject.install_at(root)
      fake_file.content.should == <<-HOOK_CODE.strip_heredoc
        #!/usr/bin/env bash

        git-tracker prepare-commit-msg "$@"

      HOOK_CODE
    end
  end

end
