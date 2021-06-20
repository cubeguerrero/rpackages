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
        process_package(data)
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

  def process_package(data)
    if package = find_package_by_name(data[:package])
      version = package.versions.where(value: data[:version]).first
      return if version
    else
      package = Package.create(name: data[:package], title: data[:title], description: data[:description]) unless package
    end
    package.versions.create(
      value: data[:version],
      published_at: DateTime.parse(data[:"date/publication"])
    )
  end

  def find_package_by_name(name)
    Package
      .includes(:versions)
      .where("packages.name = ?", name)
      .first
  end
end
