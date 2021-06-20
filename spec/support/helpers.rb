module Helpers
  def read_fixture(filename)
    File.read(File.join(File.dirname(__FILE__), "../fixtures/#{filename}"))
  end

  def open_targz(filename)
    File.open(File.join(File.dirname(__FILE__), "../fixtures/#{filename}.tar.gz"))
  end
end
