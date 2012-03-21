module GitTracker
  class CommitMessage

    def initialize(file)
      @file = file
      @message = File.read(@file)
    end

    def mentions_story?(number)
      @message =~ %r{^(?!#).*\[(\w+\s)?(#\d+\s)*##{number}(\s#\d+)*(\s\w+)?\]}
    end

  end
end
