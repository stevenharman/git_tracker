require 'git_tracker/repository'

module GitTracker
  class Hook
    attr_reader :hook_file

    def self.init
      init_at(Repository.root)
    end

    def self.init_at(root)
      new(root).write
    end

    def initialize(root)
      @hook_file = File.join(root, '.git', 'hooks', 'prepare-commit-msg')
    end

    def write
      File.open(hook_file, 'w') do |f|
        f.write(hook_body)
        f.chmod(0755)
      end
    end

    private

    def hook_body
      return <<-HOOK
#!/usr/bin/env bash

if command -v git-tracker >/dev/null; then
  git-tracker prepare-commit-msg "$@"
fi

      HOOK
    end

  end
end
