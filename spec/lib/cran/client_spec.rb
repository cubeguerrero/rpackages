require_relative '../../../lib/cran/client'

RSpec.describe CRAN::Client do
  describe '#packages' do
    it 'returns a list of packages' do
      client = CRAN::Client.new
      result = client.packages
    end
  end
end
