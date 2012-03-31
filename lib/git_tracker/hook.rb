require 'git_tracker/repository'

module GitTracker
  class Hook

    def self.install
      install_at(Repository.root)
    end

    def self.install_at(root)
      hook = hook_from(root)
      write(hook)
    end

    private

    def self.hook_from(root)
      File.join(root, '.git', 'hooks', 'prepare-commit-msg')
    end

    def self.write(hook)
      File.open(hook, 'w') do |f|
        f.write(hook_body)
        f.chmod(0755)
      end
    end

    def self.hook_body
      return <<-HOOK
#!/usr/bin/env bash

git-tracker prepare-commit-msg "$@"

      HOOK
    end

  end
end
