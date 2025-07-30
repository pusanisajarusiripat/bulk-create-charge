require "test_helper"

class SubMerchantsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sub_merchant = SubMerchant.create!(name: "Test Merchant", city: "Bangkok")
  end

  test "should get index" do
    get sub_merchants_path
    assert_response :success
  end

  test "should get show" do
    get sub_merchant_path(@sub_merchant)
    assert_response :success
  end

  test "should get new" do
    get new_sub_merchant_path
    assert_response :success
  end

  test "should create sub_merchant" do
    assert_difference("SubMerchant.count") do
      post sub_merchants_path, params: { sub_merchant: { name: "New", city: "City" } }
    end
    assert_redirected_to sub_merchant_path(SubMerchant.last)
  end

  test "should get edit" do
    get edit_sub_merchant_path(@sub_merchant)
    assert_response :success
  end

  test "should update sub_merchant" do
    patch sub_merchant_path(@sub_merchant), params: { sub_merchant: { name: "Updated" } }
    assert_redirected_to sub_merchant_path(@sub_merchant)
    @sub_merchant.reload
    assert_equal "Updated", @sub_merchant.name
  end

  test "should destroy sub_merchant" do
    assert_difference("SubMerchant.count", -1) do
      delete sub_merchant_path(@sub_merchant)
    end
    assert_redirected_to charge_path # You may want to check your redirect path
  end
end
