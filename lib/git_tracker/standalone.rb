module GitTracker
  module Standalone
    extend self

    GIT_TRACKER_ROOT = File.expand_path("../../..", __FILE__)
    PREAMBLE = <<-DOC
#
# This file is generated code. DO NOT send patches for it.
#
# Original source files with comments are at:
# https://github.com/stevenharman/git_tracker
#

DOC

    def save(filename, path = ".")
      dest = File.join(File.expand_path(path), filename)
      File.open(dest, "w") do |f|
        build(f)
        f.chmod(0o755)
      end
    end

    def build(io)
      io.puts "#!#{ruby_executable}"
      io << PREAMBLE

      each_source_file do |filename|
        File.open(filename, "r") do |source|
          inline_source(source, io)
        end
      end

      io.puts "GitTracker::Runner.execute(*ARGV)"
      io
    end

    def ruby_executable
      if File.executable? "/usr/bin/ruby" then "/usr/bin/ruby"
      else
        require "rbconfig"
        File.join(RbConfig::CONFIG["bindir"], RbConfig::CONFIG["ruby_install_name"])
      end
    end

    private

    def inline_source(code, io)
      code.each_line do |line|
        io << line unless require_own_file?(line)
      end
      io.puts ""
    end

    def require_own_file?(line)
      line =~ /^\s*require\s+["']git_tracker\//
    end

    def each_source_file
      File.open(File.join(GIT_TRACKER_ROOT, "lib/git_tracker.rb"), "r") do |main|
        main.each_line do |req|
          if req =~ /^require\s+["'](.+)["']/
            yield File.join(GIT_TRACKER_ROOT, "lib", "#{$1}.rb")
          end
        end
      end
    end
  end
end
