require "git_tracker/version"

module GitTracker
  def self.execute(hook, *args)
    hook_name = hook.gsub(/-/, '_')
    abort("git-tracker #{hook} does not exist.") unless respond_to?(hook_name)
    send(hook_name, *args)
  end

  def self.prepare_commit_msg(file, source=nil, commit_sha=nil)

  end
end
