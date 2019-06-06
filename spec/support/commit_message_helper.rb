module CommitMessageHelper
  def example_commit_message(pattern_to_match)
    <<~EXAMPLE
      Got Jenny's number, gonna' make her mine!

      #{pattern_to_match}
      # Please enter the commit message for your changes. Lines starting
      # with '#' will be ignored, and an empty message aborts the commit.
      # On branch get_jennys_number_#8675309
      # Changes to be committed:
      #   (use "git reset HEAD <file>..." to unstage)
      #
      # new file:   fake_file.rb
      #

    EXAMPLE
  end
end
