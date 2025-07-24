class BulksController < ApplicationController
  http_basic_authenticate_with name: ENV["BULK_AUTH_USER"], password: ENV["BULK_AUTH_PASSWORD"]

  def index
    # @bulks = Bulk.all
  end
end
