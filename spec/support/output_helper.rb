require "stringio"

module OutputHelper
  def capture_stderr
    old_out, new_out = $stderr, StringIO.new
    $stderr = new_out
    yield
  ensure
    $stderr = old_out
    return new_out.string
  end
end
