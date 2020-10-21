require "git_tracker/commit_message"

RSpec.describe GitTracker::CommitMessage do
  include CommitMessageHelper

  subject(:commit_message) { described_class.new(commit_editmsg_file.to_path) }
  let(:commit_editmsg_file) { Pathname(@git_dir).join("COMMIT_EDITMSG") }

  around do |example|
    Dir.mktmpdir do |dir|
      @git_dir = dir
      example.call
      remove_instance_variable(:@git_dir)
    end
  end

  it "requires path to the temporary commit message file" do
    expect { GitTracker::CommitMessage.new }.to raise_error ArgumentError
  end

  describe "#keyword" do
    %w[fix Fixed FIXES Complete completed completes FINISH finished Finishes Deliver delivered DELIVERS].each do |keyword|
      it "detects the #{keyword} keyword" do
        setup_commit_editmsg_file("Did the darn thing. [#{keyword}]")
        expect(commit_message.keyword).to eq(keyword)
      end
    end

    it "does not find the keyword when it does not exist" do
      setup_commit_editmsg_file("Did the darn thing. [Something]")
      expect(commit_message.keyword).to_not be
    end
  end

  describe "#mentions_story?" do
    context "commit message contains the special Pivotal Tracker story syntax" do
      it "allows just the number" do
        setup_commit_editmsg_file("[#8675309]")
        expect(commit_message).to be_mentions_story("8675309")
      end

      it "allows multiple numbers" do
        setup_commit_editmsg_file("[#99 #777 #8675308 #111222]")

        aggregate_failures do
          expect(commit_message).to be_mentions_story("99")
          expect(commit_message).to be_mentions_story("777")
          expect(commit_message).to be_mentions_story("8675308")
          expect(commit_message).to be_mentions_story("111222")
        end
      end

      it "allows state change before number" do
        setup_commit_editmsg_file("[Fixes #8675307]")
        expect(commit_message).to be_mentions_story("8675307")
      end

      it "allows state change after the number" do
        setup_commit_editmsg_file("[#8675306 Delivered]")
        expect(commit_message).to be_mentions_story("8675306")
      end

      it "allows surrounding text" do
        setup_commit_editmsg_file("derp de #herp [Fixes #8675305] de herp-ity derp")
        expect(commit_message).to be_mentions_story("8675305")
      end
    end

    context "commit message doesn not contain the special Pivotal Tracker story syntax" do
      it "requires brackets" do
        setup_commit_editmsg_file("#8675309")
        expect(commit_message).to_not be_mentions_story("8675309")
      end

      it "requires a pound sign" do
        setup_commit_editmsg_file("[8675309]")
        expect(commit_message).to_not be_mentions_story("8675309")
      end

      it "does not allow the bare number" do
        setup_commit_editmsg_file("8675309")
        expect(commit_message).to_not be_mentions_story("8675309")
      end

      it "does not allow multiple state changes" do
        setup_commit_editmsg_file("[Fixes Deploys #8675309]")
        expect(commit_message).to_not be_mentions_story("8675309")
      end

      it "does not allow comments" do
        setup_commit_editmsg_file("#[#8675309]")
        expect(commit_message).to_not be_mentions_story("8675309")
      end
    end
  end

  describe "#append" do
    it "handles no existing message" do
      commit_message_text = <<~COMMIT_MESSAGE


        [#8675309]
        # some other comments
      COMMIT_MESSAGE

      write_commit_editmsg_file("\n\n# some other comments\n")
      commit_message.append("[#8675309]")

      expect(commit_editmsg_file.read).to eq(commit_message_text)
    end

    it "preserves existing messages" do
      commit_message_text = <<~COMMIT_MESSAGE
        A first line

        With more here

        [#8675309]
        # other comments
      COMMIT_MESSAGE

      write_commit_editmsg_file("A first line\n\nWith more here\n# other comments\n")
      commit_message.append("[#8675309]")

      expect(commit_editmsg_file.read).to eq(commit_message_text)
    end

    it "preserves line breaks in comments" do
      commit_message_text = <<~COMMIT_MESSAGE


        [#8675309]
        # comment #1
        # comment B
        # comment III
      COMMIT_MESSAGE

      write_commit_editmsg_file("# comment #1\n# comment B\n# comment III")
      commit_message.append("[#8675309]")

      expect(commit_editmsg_file.read).to eq(commit_message_text)
    end
  end
end
