require "git_tracker/standalone"

RSpec.describe GitTracker::Standalone do
  describe "#save" do
    before do
      File.delete "git-tracker" if File.exist? "git-tracker"
    end

    after do
      File.delete "git-tracker" if File.exist? "git-tracker"
    end

    it "saves to the named file" do
      described_class.save("git-tracker")
      expect(File.size("./git-tracker")).to be > 100
    end

    it "marks the binary as executable" do
      described_class.save("git-tracker")
      expect(File).to be_executable("./git-tracker")
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

    it "includes the call to execute the hook" do
      expect(standalone_script).to include("GitTracker::Runner.execute(*ARGV)")
    end

    it "excludes requiring git_tracker code" do
      expect(standalone_script).to_not match(/^require\s+["']git_tracker/)
    end
  end
end
