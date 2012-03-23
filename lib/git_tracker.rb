require "git_tracker/version"
require "git_tracker/prepare_commit_message"

module GitTracker
  def self.execute(cmd_arg, *args)
    command = cmd_arg.gsub(/-/, '_')
    abort("[git_tracker] command: '#{cmd_arg}' does not exist.") unless respond_to?(command)
    send(command, *args)
  end

  def self.prepare_commit_msg(*args)
    PrepareCommitMessage.run(*args)
  end
end
