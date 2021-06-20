require_relative '../../lib/cran/client'
require_relative '../../lib/util/util/tar'

class PackageFetcher
  def initialize(cran_client: CRAN::Client.new)
    @cran_client = cran_client
    @status = nil
  end

  def run!
    result = @cran_client.packages
    if result.successful?
      result.packages.map do |p|
        description = fetch_description(p[:package], p[:version])
        data = p.merge(description)
        package = find_package_by_name(data[:package])
        package = Package.create(name: data[:package], title: data[:title], description: data[:description]) unless package
        package.versions.create(
          value: data[:version],
          published_at: DateTime.parse(data[:"date/publication"])
        )
      end
      @status = :success
    else
      @status = :failure
    end
  end

  def successful?
    @status == :success
  end


  private

  def fetch_description(name, version)
    result = @cran_client.fetch_tar(name, version)
    io = Util::Tar.ungzip(result.tar)
    description = Util::Tar.fetch_description_from_tar(io)
    Util.parse_package(description)
  end

  def find_package_by_name(name)
    Package
      .includes(:versions)
      .where("packages.name = ?", name)
      .first
  end
end
