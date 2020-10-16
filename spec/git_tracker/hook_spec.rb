require "git_tracker/hook"
require "active_support/core_ext/string/strip"

RSpec.describe GitTracker::Hook do
  subject(:hook) { described_class }
  let(:root) { "/path/to/git/repo/toplevel" }
  let(:hook_path) { File.join(root, ".git", "hooks", "prepare-commit-msg") }

  describe ".init" do
    before do
      allow(GitTracker::Repository).to receive(:root) { root }
      allow(hook).to receive(:init_at)
    end

    it "initializes to the root of the Git repository" do
      hook.init
      expect(hook).to have_received(:init_at).with(root)
    end
  end

  describe ".init_at" do
    let(:fake_file) { GitTracker::FakeFile.new }
    before do
      allow(File).to receive(:open).and_yield(fake_file)
    end

    it "writes the hook into the hooks directory" do
      hook.init_at(root)
      expect(File).to have_received(:open).with(hook_path, "w")
    end

    it "makes the hook executable" do
      hook.init_at(root)
      expect(fake_file.mode).to eq(0o755)
    end

    it "writes the hook code in the hook file" do
      hook_code = <<-HOOK_CODE.strip_heredoc
        #!/usr/bin/env bash

        if command -v git-tracker >/dev/null; then
          git-tracker prepare-commit-msg "$@"
        fi

      HOOK_CODE

      hook.init_at(root)
      expect(fake_file.content).to eq(hook_code)
    end
  end
end
