require 'faraday'
require_relative './result'

module CRAN
  class Client
    BASE_URL = 'https://cran.r-project.org/src/contrib'

    def packages
      response = get('PACKAGES')
      Result.new(status: response.status, packages: response.body)
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
