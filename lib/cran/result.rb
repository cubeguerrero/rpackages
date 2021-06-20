require_relative '../util/util'

module CRAN
  class Result
    attr_reader :packages
    attr_reader :status

    def initialize(packages:, status:)
      @status = status
      @packages = process_packages(packages)
    end

    def successful?
      @status == 200
    end

    private

    def process_packages(packages)
      return [] unless successful?
      packages.split("\n\n").map {|p| Util.parse_package(p) }
    end
  end
end
