require "test_helper"

class ChargesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get charges_url
    assert_response :success
  end
end
