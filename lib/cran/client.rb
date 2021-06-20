require 'faraday'
require 'open-uri'
require_relative './result'

module CRAN
  class Client
    BASE_URL = 'https://cran.r-project.org/src/contrib'

    def packages
      response = get('PACKAGES')
      Result.new(status: response.status, packages: response.body)
    end

    def fetch_tar(package_name, version)
      f = URI.open("#{BASE_URL}/#{package_name}_#{version}.tar.gz")
      Result.new(status: 200, packages: '', tar: f)
    rescue OpenURI::HTTPError
      Result.new(status: 404)
    end

    private

    def get(endpoint, params={})
      connection.get(endpoint ,params)
    end

    def connection
      @connection ||= Faraday.new(url: BASE_URL)
    end
  end
end
