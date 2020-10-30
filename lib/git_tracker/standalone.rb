require "pathname"

module GitTracker
  module Standalone
    extend self

    GIT_TRACKER_ROOT = Pathname(__dir__).join("../..")
    PREAMBLE = <<~DOC
      #
      # This file is generated code. DO NOT send patches for it.
      #
      # Original source files with comments are at:
      # https://github.com/stevenharman/git_tracker
      #
    DOC

    def build(io)
      io.puts("#!/usr/bin/env ruby")
      io.puts(PREAMBLE)

      each_source_file do |filename|
        Pathname(filename).open("r") do |source|
          inline_source(source, io)
        end
      end

      io.puts("GitTracker::Runner.call(*ARGV)")
      io
    end

    def save(filename, path: ".")
      dest = Pathname(path).join(filename).expand_path
      dest.open("w") do |f|
        build(f)
        f.chmod(0o755)
      end
    end

    private

    def each_source_file
      GIT_TRACKER_ROOT.join("lib/git_tracker.rb").open("r") do |main|
        main.each_line do |req|
          if req =~ /^require\s+["']git_tracker\/(.+)["']/
            yield GIT_TRACKER_ROOT.join("lib/git_tracker/#{$1}.rb").to_path
          end
        end
      end
    end

    def inline_source(code, io)
      code.each_line do |line|
        io << line unless require_own_file?(line)
      end
      io.puts("")
    end

    def require_own_file?(line)
      /^\s*require\s+["']git_tracker\//.match?(line)
    end
  end
end
