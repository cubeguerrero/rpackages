require 'rails_helper'
require_relative '../../../lib/cran/client'

RSpec.describe CRAN::Client do
  describe "#packages" do
    it "returns a list of packages" do
      VCR.use_cassette "packages_success" do
        client = CRAN::Client.new
        result = client.packages

        expect(result).to be_successful
      end
    end
  end
end
