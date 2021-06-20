class PackagesController < ApplicationController
  def index
    @packages = Package.includes(:versions).all
  end

  def show
    @package = Package.find(params[:id])
  end
end
