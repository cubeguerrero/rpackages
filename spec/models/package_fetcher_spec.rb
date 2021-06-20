require "rails_helper"

RSpec.describe PackageFetcher do
  let(:fetcher) { PackageFetcher.new }

  describe "#run!" do
    let(:package_result) do
      CRAN::Result.new(status: 200, packages: "Package: A3\nVersion: 1.0.0\nDepends: R (>= 2.15.0), xtable, pbapply\nSuggests: randomForest, e1071\nLicense: GPL (>= 2)\nMD5sum: 027ebdd8affce8f0effaecfcd5f5ade2\nNeedsCompilation: no")
    end
    let(:tar_result) do
      CRAN::Result.new(status: 200, tar: open_targz("A3_1.0.0"))
    end

    before do
      allow_any_instance_of(CRAN::Client).to receive(:packages).and_return(package_result)
      allow_any_instance_of(CRAN::Client).to receive(:fetch_tar).with("A3", "1.0.0").and_return(tar_result)
    end

    it "is successful" do
      fetcher.run!

      expect(fetcher).to be_successful
    end

    it "creates a package" do
      fetcher.run!
      package = Package.find_by(name: "A3")
      expect(package).not_to be_nil
      expect(package.title).to eq "Accurate, Adaptable, and Accessible Error Metrics for Predictive Models"
      expect(package.description).to eq "Supplies tools for tabulating and analyzing the results of predictive models. The methods employed are applicable to virtually any predictive model and make comparisons between different methodologies straightforward."
    end

    context "package already exist" do
      before do
        Package.create(
          name: "A3",
          title: "Accurate, Adaptable, and Accessible Error Metrics for Predictive Models",
          description: "Supplies tools for tabulating and analyzing the results of predictive models. The methods employed are applicable to virtually any predictive model and make comparisons between different methodologies straightforward."
        )
      end

      it "does not create a duplicate package for same package" do
        expect(Package.count).to eq 1

        fetcher.run!

        expect(Package.count).to eq 1
      end
    end
  end
end
