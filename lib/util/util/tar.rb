require "rubygems/package"

module Util
  module Tar
    def self.ungzip(tarfile)
      z = Zlib::GzipReader.new(tarfile)
      unzipped = StringIO.new(z.read)
      z.close
      unzipped
    end

    def self.fetch_description_from_tar(tar_io)
      result = ""
      Gem::Package::TarReader.new(tar_io) do |tar|
        tar.each do |entry|
          if !entry.directory? && entry.full_name.include?("DESCRIPTION")
            result = entry.read
          end
        end
      end
      result
    end
  end
end
