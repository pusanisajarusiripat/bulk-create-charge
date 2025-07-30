require "test_helper"

class ChargesControllerTest < ActionDispatch::IntegrationTest
  include ActionDispatch::TestProcess

  setup do
    @bulk = Bulk.create!(file: fixture_file_upload("bulk_create_test.csv", "text/csv"))
    @charge = @bulk.charges.create!(amount: 1000, currency: "THB")
  end

  test "should get index" do
    get charges_path
    assert_response :success
  end

  test "should get show" do
    get charge_path(@charge)
    assert_response :success
  end
end
