require "git_tracker/version"

module GitTracker
  def self.execute(hook, *args)
    hook_name = hook.gsub(/-/, '_')
    send(hook_name, *args) if respond_to?(hook_name)
  end

  def self.prepare_commit_msg(file, source=nil, commit_sha=nil)

  end
end
