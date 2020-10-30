require "pathname"

module GitTracker
  class CommitMessage
    def initialize(file)
      @file = Pathname(file)
    end

    def append(text)
      body, postscript = parse(message)
      new_message = format_message(body, text, postscript)

      file.open("w") do |f|
        f.write(new_message)
      end

      new_message
    end

    def keyword
      matches = message.match(KEYWORD_REGEX) || {}
      matches[:keyword]
    end

    def mentions_story?(number)
      /^(?!#).*\[(\w+\s)?(#\d+\s)*##{number}(\s#\d+)*(\s\w+)?\]/i.match?(message)
    end

    private

    KEYWORD_REGEX = /\[(?<keyword>fix|fixes|fixed|complete|completes|completed|finish|finishes|finished|deliver|delivers|delivered)\]/io.freeze
    private_constant :KEYWORD_REGEX

    attr_reader :file

    def format_message(preamble, text, postscript)
      <<~MESSAGE
        #{preamble.strip}

        #{text}
        #{postscript}
      MESSAGE
    end

    def message
      @message ||= file.read.freeze
    end

    def parse(raw_message)
      lines = raw_message.split($/)
      body = lines.take_while { |line| !line.start_with?("#") }
      postscript = lines.slice(body.length..-1)
      [body.join("\n"), postscript.join("\n")]
    end
  end
end
