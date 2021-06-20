class PackagesController < ApplicationController
  def index
    # Had no time but this would be better to paginate this
    @packages = Package.all
  end

  def show
  end
end
