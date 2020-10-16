require "git_tracker/commit_message"
require "active_support/core_ext/string/strip"

RSpec.describe GitTracker::CommitMessage do
  include CommitMessageHelper

  subject(:commit_message) { described_class.new(file) }
  let(:file) { "COMMIT_EDITMSG" }

  it "requires path to the temporary commit message file" do
    expect { GitTracker::CommitMessage.new }.to raise_error ArgumentError
  end

  def stub_commit_message(story_text)
    allow(File).to receive(:read).with(file) { example_commit_message(story_text) }
  end

  describe "#keyword" do
    %w[fix Fixed FIXES Complete completed completes FINISH finished Finishes Deliver delivered DELIVERS].each do |keyword|
      it "detects the #{keyword} keyword" do
        stub_commit_message("Did the darn thing. [#{keyword}]")
        expect(commit_message.keyword).to eq(keyword)
      end
    end

    it "does not find the keyword when it does not exist" do
      stub_commit_message("Did the darn thing. [Something]")
      expect(commit_message.keyword).to_not be
    end
  end

  describe "#mentions_story?" do
    context "commit message contains the special Pivotal Tracker story syntax" do
      it "allows just the number" do
        stub_commit_message("[#8675309]")
        expect(commit_message).to be_mentions_story("8675309")
      end

      it "allows multiple numbers" do
        stub_commit_message("[#99 #777 #8675309 #111222]")
        expect(commit_message).to be_mentions_story("99")
        expect(commit_message).to be_mentions_story("777")
        expect(commit_message).to be_mentions_story("8675309")
        expect(commit_message).to be_mentions_story("111222")
      end

      it "allows state change before number" do
        stub_commit_message("[Fixes #8675309]")
        expect(commit_message).to be_mentions_story("8675309")
      end

      it "allows state change after the number" do
        stub_commit_message("[#8675309 Delivered]")
        expect(commit_message).to be_mentions_story("8675309")
      end

      it "allows surrounding text" do
        stub_commit_message("derp de #herp [Fixes #8675309] de herp-ity derp")
        expect(commit_message).to be_mentions_story("8675309")
      end
    end

    context "commit message doesn not contain the special Pivotal Tracker story syntax" do
      it "requires brackets" do
        stub_commit_message("#8675309")
        expect(commit_message).to_not be_mentions_story("8675309")
      end

      it "requires a pound sign" do
        stub_commit_message("[8675309]")
        expect(commit_message).to_not be_mentions_story("8675309")
      end

      it "does not allow the bare number" do
        stub_commit_message("8675309")
        expect(commit_message).to_not be_mentions_story("8675309")
      end

      it "does not allow multiple state changes" do
        stub_commit_message("[Fixes Deploys #8675309]")
        expect(commit_message).to_not be_mentions_story("8675309")
      end

      it "does not allow comments" do
        stub_commit_message("#[#8675309]")
        expect(commit_message).to_not be_mentions_story("8675309")
      end
    end
  end

  describe "#append" do
    let(:fake_file) { GitTracker::FakeFile.new }
    before do
      allow(File).to receive(:open).and_yield(fake_file)
    end
    def stub_original_commit_message(message)
      allow(File).to receive(:read) { message }
    end

    it "handles no existing message" do
      commit_message_text = <<-COMMIT_MESSAGE.strip_heredoc


        [#8675309]
        # some other comments
      COMMIT_MESSAGE

      stub_original_commit_message("\n\n# some other comments\n")
      commit_message.append("[#8675309]")

      expect(fake_file.content).to eq(commit_message_text)
    end

    it "preserves existing messages" do
      commit_message_text = <<-COMMIT_MESSAGE.strip_heredoc
        A first line

        With more here

        [#8675309]
        # other comments
      COMMIT_MESSAGE

      stub_original_commit_message("A first line\n\nWith more here\n# other comments\n")
      commit_message.append("[#8675309]")

      expect(fake_file.content).to eq(commit_message_text)
    end

    it "preserves line breaks in comments" do
      commit_message_text = <<-COMMIT_MESSAGE.strip_heredoc


        [#8675309]
        # comment #1
        # comment B
        # comment III
      COMMIT_MESSAGE

      stub_original_commit_message("# comment #1\n# comment B\n# comment III")
      commit_message.append("[#8675309]")

      expect(fake_file.content).to eq(commit_message_text)
    end
  end
end
