require "stringio"

module OutputHelper
  def capture_stderr
    old_out, new_out = $stderr, StringIO.new
    $stderr = new_out
    yield
    new_out.string
  ensure
    $stderr = old_out
  end
end
