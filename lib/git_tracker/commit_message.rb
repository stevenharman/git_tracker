module GitTracker
  class CommitMessage

    def initialize(file)
      @file = file
    end

    def mentions_story?(number)
      message = File.read(@file)
      message =~ %r{^(?!#).*\[(\w+\s)?(#\d+\s)*##{number}(\s#\d+)*(\s\w+)?\]}
    end

  end
end
