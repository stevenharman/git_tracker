require 'spec_helper'
require 'git_tracker/hook'
require 'active_support/core_ext/string/strip'

describe GitTracker::Hook do
  subject(:hook) { described_class }
  let(:root) { '/path/to/git/repo/toplevel' }
  let(:hook_path) { File.join(root, '.git', 'hooks', 'prepare-commit-msg') }

  describe '.install' do
    before do
      GitTracker::Repository.stub(:root) { root }
    end

    it 'installs to the root of the Git repository' do
      hook.should_receive(:install_at).with(root)
      hook.install
    end
  end

  describe '.install_at' do
    let(:fake_file) { GitTracker::FakeFile.new }
    before do
      File.stub(:open).and_yield(fake_file)
    end

    it 'writes the hook into the hooks directory' do
      File.should_receive(:open).with(hook_path, 'w')
      hook.install_at(root)
    end

    it 'makes the hook executable' do
      hook.install_at(root)
      expect(fake_file.mode).to eq(0755)
    end

    it 'writes the hook code in the hook file' do
      hook_code = <<-HOOK_CODE.strip_heredoc
        #!/usr/bin/env bash

        git-tracker prepare-commit-msg "$@"

      HOOK_CODE

      hook.install_at(root)
      expect(fake_file.content).to eq(hook_code)
    end
  end

end
