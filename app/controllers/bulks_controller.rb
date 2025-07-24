class BulksController < ApplicationController
  http_basic_authenticate_with name: "user", password: "secret"

  def index
    # @bulks = Bulk.all
  end
end
