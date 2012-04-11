require 'spec_helper'
require 'git_tracker/commit_message'
require 'active_support/core_ext/string/strip'

describe GitTracker::CommitMessage do
  include CommitMessageHelper

  subject { described_class.new(file) }
  let(:file) { "COMMIT_EDITMSG" }

  it "requires path to the temporary commit message file" do
    lambda { GitTracker::CommitMessage.new }.should raise_error ArgumentError
  end

  describe "#mentions_story?" do
    def stub_commit_message(story_text)
      File.stub(:read).with(file) { example_commit_message(story_text) }
    end

    context "commit message contains the special Pivotal Tracker story syntax" do
      it "allows just the number" do
        stub_commit_message("[#8675309]")
        subject.should be_mentions_story("8675309")
      end

      it "allows multiple numbers" do
        stub_commit_message("[#99 #777 #8675309 #111222]")
        subject.should be_mentions_story("99")
        subject.should be_mentions_story("777")
        subject.should be_mentions_story("8675309")
        subject.should be_mentions_story("111222")
      end

      it "allows state change before number" do
        stub_commit_message("[Fixes #8675309]")
        subject.should be_mentions_story("8675309")
      end

      it "allows state change after the number" do
        stub_commit_message("[#8675309 Delivered]")
        subject.should be_mentions_story("8675309")
      end

      it "allows surrounding text" do
        stub_commit_message("derp de #herp [Fixes #8675309] de herp-ity derp")
        subject.should be_mentions_story("8675309")
      end
    end

    context "commit message doesn't contain the special Pivotal Tracker story syntax" do
      it "requires brackets" do
        stub_commit_message("#8675309")
        subject.should_not be_mentions_story("8675309")
      end

      it "requires a pound sign" do
        stub_commit_message("[8675309]")
        subject.should_not be_mentions_story("8675309")
      end

      it "doesn't allow the bare number" do
        stub_commit_message("8675309")
        subject.should_not be_mentions_story("8675309")
      end

      it "doesn't allow multiple state changes" do
        stub_commit_message("[Fixes Deploys #8675309]")
        subject.should_not be_mentions_story("8675309")
      end

      it "doesn't allow comments" do
        stub_commit_message("#[#8675309]")
        subject.should_not be_mentions_story("8675309")
      end
    end
  end

  describe "#append" do
    let(:fake_file) { GitTracker::FakeFile.new }
    before do
      File.stub(:open).and_yield(fake_file)
    end
    def stub_original_commit_message(message)
      File.stub(:read) { message }
    end

    it "handles no existing message" do
      stub_original_commit_message("\n\n# some other comments\n")
      subject.append("[#8675309]")

      fake_file.content.should == <<-COMMIT_MESSAGE.strip_heredoc


        [#8675309]
        # some other comments
      COMMIT_MESSAGE
    end

    it "preserves existing messages" do
      stub_original_commit_message("A first line\n\nWith more here\n# other comments\n")
      subject.append("[#8675309]")

      fake_file.content.should == <<-COMMIT_MESSAGE.strip_heredoc
        A first line

        With more here

        [#8675309]
        # other comments
      COMMIT_MESSAGE
    end

    it "preserves line breaks in comments" do
      stub_original_commit_message("# comment #1\n# comment B\n# comment III")
      subject.append("[#8675309]")

      fake_file.content.should == <<-COMMIT_MESSAGE.strip_heredoc


        [#8675309]
        # comment #1
        # comment B
        # comment III
      COMMIT_MESSAGE
    end
  end

end
