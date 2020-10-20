module GitTracker
  class CommitMessage
    def initialize(file)
      @file = file
      @message = File.read(@file)
    end

    def mentions_story?(number)
      @message =~ /^(?!#).*\[(\w+\s)?(#\d+\s)*##{number}(\s#\d+)*(\s\w+)?\]/i
    end

    def keyword
      @message =~ /\[(fix|fixes|fixed|complete|completes|completed|finish|finishes|finished|deliver|delivers|delivered)\]/io
      $1
    end

    def append(text)
      body, postscript = parse(@message)
      new_message = format_message(body, text, postscript)
      File.open(@file, "w") do |f|
        f.write(new_message)
      end
      new_message
    end

    private

    def parse(message)
      lines = message.split($/)
      body = lines.take_while { |line| !line.start_with?("#") }
      postscript = lines.slice(body.length..-1)
      [body.join("\n"), postscript.join("\n")]
    end

    def format_message(preamble, text, postscript)
      <<~MESSAGE
        #{preamble.strip}

        #{text}
        #{postscript}
      MESSAGE
    end
  end
end
