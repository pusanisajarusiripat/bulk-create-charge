require "test_helper"

class BulksControllerTest < ActionDispatch::IntegrationTest
  include ActionDispatch::TestProcess
  include ActionController::HttpAuthentication::Basic

  setup do
    @bulk = Bulk.create!(file: fixture_file_upload("bulk_create_test.csv", "text/csv"))
    @auth_headers = {
      "HTTP_AUTHORIZATION" => encode_credentials(ENV["BULK_AUTH_USER"], ENV["BULK_AUTH_PASSWORD"])
    }
  end

  test "should get index" do
    get bulks_path, headers: @auth_headers
    assert_response :success
  end

  test "should get show" do
    get bulk_path(@bulk), headers: @auth_headers
    assert_response :success
  end

  test "should get new" do
    get new_bulk_path, headers: @auth_headers
    assert_response :success
  end

  test "should not create bulk without file" do
    assert_no_difference("Bulk.count") do
      post bulks_path, params: { bulk: { file: nil } }, headers: @auth_headers
    end
    assert_response :success
  end
end
