module GitTracker
  class CommitMessage

    def initialize(file)
      @file = file
    end

    def contains?(pattern)
      message = File.read(@file)
      message.include?(pattern)
    end

  end
end
