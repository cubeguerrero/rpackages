require 'rails_helper'
require_relative '../../../../lib/util/util/tar'

RSpec.describe Util::Tar do
  describe '.ungzip' do
    it 'returns a StringIO' do
      file = open_targz('A3_1.0.0')
      io = Util::Tar.ungzip(file)

      expect(io).to be_a StringIO
    end
  end

  describe ".fetch_description_from_tar" do
    context "tar with DESCRIPTION file" do
      it "returns the contents of DESCRIPTION" do
        file = open_targz('A3_1.0.0')
        io = Util::Tar.ungzip(file)
        description = Util::Tar.fetch_description_from_tar(io)

        expect(description).to include "A3"
      end
    end
  end
end
