module GitTracker
  class FakeFile
    attr_reader :content

    def write(content)
      @content = content
    end
  end
end
