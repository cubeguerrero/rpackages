require 'byebug'
require_relative '../../../lib/cran/result'

RSpec.describe CRAN::Result do
  describe "#packages" do
    it "returns a list of package hashes" do
      data = """Package: A3
Version: 1.0.0
Depends: R (>= 2.15.0), xtable, pbapply
Suggests: randomForest, e1071
License: GPL (>= 2)
MD5sum: 027ebdd8affce8f0effaecfcd5f5ade2
NeedsCompilation: no

Package: aaSEA
Version: 1.1.0
Depends: R(>= 3.4.0)
Imports: DT(>= 0.4), networkD3(>= 0.4), shiny(>= 1.0.5),
        shinydashboard(>= 0.7.0), magrittr(>= 1.5), Bios2cor(>= 2.0),
        seqinr(>= 3.4-5), plotly(>= 4.7.1), Hmisc(>= 4.1-1)
Suggests: knitr, rmarkdown
License: GPL-3
MD5sum: 0f9aaefc1f1cf18b6167f85dab3180d8
NeedsCompilation: no

Package: AATtools
Version: 0.0.1
Depends: R (>= 3.6.0)
Imports: magrittr, dplyr, doParallel, foreach
License: GPL-3
MD5sum: 3bd92dbd94573afb17ebc5eab23473cb
NeedsCompilation: no"""

      result = CRAN::Result.new(packages: data, status: 200)
      packages = result.packages

      expect(packages.length).to eq 3

      expect(packages[0][:package]).to eq 'A3'
      expect(packages[0][:version]).to eq '1.0.0'
      expect(packages[0][:imports]).to be_nil
      expect(packages[0][:depends]).to eq 'R (>= 2.15.0), xtable, pbapply'
      expect(packages[0][:suggests]).to eq 'randomForest, e1071'
      expect(packages[0][:license]).to eq 'GPL (>= 2)'
      expect(packages[0][:md5sum]).to eq '027ebdd8affce8f0effaecfcd5f5ade2'
      expect(packages[0][:needs_compilation]).to eq 'no'

      expect(packages[1][:package]).to eq 'aaSEA'
      expect(packages[1][:version]).to eq '1.1.0'
      expect(packages[1][:depends]).to eq 'R(>= 3.4.0)'
      expect(packages[1][:imports]).to eq 'DT(>= 0.4), networkD3(>= 0.4), shiny(>= 1.0.5), shinydashboard(>= 0.7.0), magrittr(>= 1.5), Bios2cor(>= 2.0), seqinr(>= 3.4-5), plotly(>= 4.7.1), Hmisc(>= 4.1-1)'
      expect(packages[1][:suggests]).to eq 'knitr, rmarkdown'
      expect(packages[1][:license]).to eq 'GPL-3'
      expect(packages[1][:md5sum]).to eq '0f9aaefc1f1cf18b6167f85dab3180d8'
      expect(packages[1][:needs_compilation]).to eq 'no'
    end
  end

  describe "#successful?" do
    context "status is 200" do
      it "returns true" do
        result = CRAN::Result.new(packages: "", status: 200)
        expect(result).to be_successful
      end
    end

    context "status is 400" do
      it "returns false" do
        result = CRAN::Result.new(packages: "", status: 400)
        expect(result).not_to be_successful
      end
    end
  end
end
