require 'rails_helper'
require_relative '../../../lib/cran/client'

RSpec.describe CRAN::Client do
  describe "#packages" do
    context "successful request" do
      it "returns a successful CRAN::Result" do
        VCR.use_cassette "packages_success" do
          client = CRAN::Client.new
          result = client.packages

          expect(result).to be_successful
        end
      end
    end

    context "request not found" do
      it "returns an unsuccessful CRAN::Result" do
        VCR.use_cassette "not_found" do
          client = CRAN::Client.new
          result = client.packages

          expect(result).not_to be_successful
        end
      end
    end
  end
end
