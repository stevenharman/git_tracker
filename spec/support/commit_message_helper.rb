module CommitMessageHelper
  def example_commit_message(pattern:)
    <<~EXAMPLE
      Got Jenny's number, gonna' make her mine!

      #{pattern}
      # Please enter the commit message for your changes. Lines starting
      # with '#' will be ignored, and an empty message aborts the commit.
      # On branch just_a_branchy_##{pattern}
      # Changes to be committed:
      #   (use "git reset HEAD <file>..." to unstage)
      #
      # new file:   fake_file.rb
      #

    EXAMPLE
  end

  # NOTE: The default value of `file` is ✨ magically ✨ assumed to just exist.
  # So either pass it in explicitly, or use a `let` to define it.
  def setup_commit_editmsg_file(story_text, file: commit_editmsg_file)
    body = example_commit_message(pattern: story_text)
    write_commit_editmsg_file(body, file: file)
  end

  def write_commit_editmsg_file(body, file: commit_editmsg_file)
    Pathname(file).open("w") do |f|
      f.write(body)
    end
  end
end
