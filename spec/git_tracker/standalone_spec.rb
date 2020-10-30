require "git_tracker/standalone"

RSpec.describe GitTracker::Standalone do
  describe "#save" do
    let(:binary) { Pathname(pkg_dir).join("git-tracker") }
    let(:pkg_dir) { Pathname(@pkg_dir).to_path }

    around do |example|
      Dir.mktmpdir do |dir|
        @pkg_dir = dir
        example.call
        remove_instance_variable(:@pkg_dir)
      end
    end

    it "saves to the named file" do
      described_class.save("git-tracker", path: pkg_dir)
      expect(binary.size).to be > 100
    end

    it "marks the binary as executable" do
      described_class.save("git-tracker", path: pkg_dir)
      expect(binary).to be_executable
    end
  end

  describe "#build" do
    subject(:standalone_script) { described_class.build(io).string }
    let(:io) { StringIO.new }

    it "declares a shebang" do
      expect(standalone_script).to match(/#!.+/)
    end

    it "includes generated code notice" do
      expect(standalone_script).to include("This file is generated")
    end

    it "inlines the code" do
      expect(standalone_script).to include("Hook")
      expect(standalone_script).to include("Repository")
      expect(standalone_script).to include("PrepareCommitMessage")
      expect(standalone_script).to include("Runner")
      expect(standalone_script).to include("Branch")
      expect(standalone_script).to include("CommitMessage")
      expect(standalone_script).to include("VERSION")
    end

    it "inlines the message HEREDOC" do
      expect(standalone_script).to include("\#{preamble.strip}")
    end

    it "inlines the shebang for the hook" do
      expect(standalone_script).to include("#!/usr/bin/env bash")
    end

    it "does not inline the standalone code" do
      expect(standalone_script).to_not include("module Standalone")
    end

    it "includes the call to call the hook" do
      expect(standalone_script).to include("GitTracker::Runner.call(*ARGV)")
    end

    it "includes requiring code from stdlib" do
      expect(standalone_script).to match(/^require\s+["']pathname/)
    end

    it "excludes requiring git_tracker code" do
      expect(standalone_script).to_not match(/^require\s+["']git_tracker/)
    end
  end
end
