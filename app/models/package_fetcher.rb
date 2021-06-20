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
    return unless need_to_process?(data[:package], data[:version])

    package = find_package_by_name(data[:package])
    unless package
      package = Package.create(
        name: data[:package],
        title: data[:title],
        description: data[:description]
      )
    end
    process_version(package, data)
    process_authors(package, data)
    process_maintainers(package, data)
  end

  def find_package_by_name(name)
    Package
      .includes(:versions)
      .where("packages.name = ?", name)
      .first
  end

  def need_to_process?(name, version)
    Package
      .joins(:versions)
      .where("packages.name = ?", name)
      .where("versions.value = ?", version)
  end

  def process_version(package, data)
    package.versions.create(
      value: data[:version],
      published_at: DateTime.parse(data[:"date/publication"])
    )
  end

  def process_authors(package, data)
    authors = data[:author].split(",")
    authors.each do |author_name|
      author = Person.find_or_create_by(name: author_name.strip)
      package.authors << author
    end
  end

  def process_maintainers(package, data)
    maintainers = data[:maintainer].split(",")
    maintainers.each do |maintainer_data|
      name, email = maintainer_data.split("<")
      email = email.strip[(0...-1)]
      maintainer = Person.find_or_create_by(name: name.strip)
      maintainer.email = email
      maintainer.save!
      package.maintainers << maintainer
    end
  end
end
