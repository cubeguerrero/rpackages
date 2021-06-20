require_relative '../util/util'

module CRAN
  class Result
    attr_reader :status, :packages, :tar

    def initialize(status:, packages: '', tar: nil)
      @status = status
      @packages = process_packages(packages)
      @tar = tar
    end

    def successful?
      @status == 200
    end

    private

    def process_packages(packages)
      return '' if packages == ''
      return [] unless successful?
      packages.split("\n\n").map {|p| Util.parse_package(p) }
    end
  end
end
