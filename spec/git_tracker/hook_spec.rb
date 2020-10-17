require "git_tracker/hook"

RSpec.describe GitTracker::Hook do
  subject(:hook) { described_class.new(at: Pathname(@repo_root_dir)) }

  around do |example|
    Dir.mktmpdir do |dir|
      @repo_root_dir = dir
      hooks_dir = Pathname(dir).join(".git/hooks")
      FileUtils.mkdir_p(hooks_dir)
      example.call
    end
  end

  it "makes the hook executable" do
    hook.write

    expect(hook.hook_file).to be_executable
  end

  it "writes the hook code in the hook file" do
    hook.write

    expect(hook.hook_file.read).to eq(described_class::BODY)
  end
end
