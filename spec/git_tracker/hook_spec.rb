require 'spec_helper'
require 'git_tracker/hook'
require 'active_support/core_ext/string/strip'

describe GitTracker::Hook do
  subject(:hook) { described_class }
  let(:root) { '/path/to/git/repo/toplevel' }
  let(:hook_path) { File.join(root, '.git', 'hooks', 'prepare-commit-msg') }

  describe '.init' do
    before do
      GitTracker::Repository.stub(:root) { root }
      hook.stub(:init_at)
    end

    it 'initializes to the root of the Git repository' do
      hook.init
      expect(hook).to have_received(:init_at).with(root)
    end
  end

  describe '.init_at' do
    let(:fake_file) { GitTracker::FakeFile.new }
    before do
      File.stub(:open).and_yield(fake_file)
    end

    it 'writes the hook into the hooks directory' do
      hook.init_at(root)
      expect(File).to have_received(:open).with(hook_path, 'w')
    end

    it 'makes the hook executable' do
      hook.init_at(root)
      expect(fake_file.mode).to eq(0755)
    end

    it 'writes the hook code in the hook file' do
      hook_code = <<-HOOK_CODE.strip_heredoc
        #!/usr/bin/env bash

        git-tracker prepare-commit-msg "$@"

      HOOK_CODE

      hook.init_at(root)
      expect(fake_file.content).to eq(hook_code)
    end
  end

end
