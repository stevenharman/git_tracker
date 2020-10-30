require "pathname"
require "git_tracker/repository"

module GitTracker
  class Hook
    BODY = <<~HOOK.freeze
      #!/usr/bin/env bash

      if command -v git-tracker >/dev/null; then
        git-tracker prepare-commit-msg "$@"
      fi

    HOOK

    attr_reader :hook_file

    def self.init(at:)
      new(at: at).write
    end

    def initialize(at:)
      @hook_file = Pathname(at).join(PREPARE_COMMIT_MSG_PATH)
    end

    def write
      hook_file.open("w") do |f|
        f.write(BODY)
        f.chmod(0o755)
      end
    end

    PREPARE_COMMIT_MSG_PATH = ".git/hooks/prepare-commit-msg".freeze
    private_constant :PREPARE_COMMIT_MSG_PATH
  end
end
