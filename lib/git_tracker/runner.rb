require "optparse"
require "git_tracker/prepare_commit_message"
require "git_tracker/hook"
require "git_tracker/repository"
require "git_tracker/version"

module GitTracker
  class Runner
    def self.call(*args, io: $stdout)
      args << "--help" if args.empty?
      options = {}

      OptionParser.new { |optparse|
        optparse.banner = <<~BANNER
          git-tracker is a Git hook used during the normal lifecycle of committing,
          rebasing, merging, etc… This hook must be initialized into each repository
          in which you wish to use it.

          usage: git-tracker init
        BANNER

        optparse.on("-h", "--help", "Prints this help") do
          io.puts(optparse)
          options[:exit] = true
        end

        optparse.on("-v", "--version", "Prints the git-tracker version number") do
          io.puts("git-tracker #{VERSION}")
          options[:exit] = true
        end
      }.parse!(args)

      return if options.fetch(:exit, false)

      command, *others = args

      new(command: command, arguments: others, options: options).call
    end

    def initialize(command:, arguments:, options:)
      @command = command
      @arguments = arguments
      @options = options
    end

    def call
      abort("[git_tracker] command: '#{command}' does not exist.") unless sub_command

      send(sub_command)
    end

    private

    SUB_COMMANDS = {
      init: :init,
      install: :install,
      "prepare-commit-msg": :prepare_commit_msg
    }.freeze
    private_constant :SUB_COMMANDS

    attr_reader :arguments, :command, :options

    def init
      Hook.init(at: Repository.root)
    end

    def install
      warn("`git-tracker install` is deprecated. Please use `git-tracker init`.")

      init
    end

    def prepare_commit_msg
      PrepareCommitMessage.call(*arguments)
    end

    def sub_command
      @sub_command ||= SUB_COMMANDS.fetch(command.intern, false)
    end
  end
end
