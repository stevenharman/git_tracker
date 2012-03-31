module GitTracker
  class FakeFile
    attr_reader :content, :mode

    def write(content)
      @content = content
    end

    def chmod(mode_int)
      @mode = mode_int
    end
  end
end
