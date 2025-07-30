require "test_helper"

class SubMerchantTest < ActiveSupport::TestCase
  test "should not be valid" do
    sub_merchant = SubMerchant.new
    assert_not sub_merchant.valid?
  end

  test "should be valid with name and city" do
    sub_merchant = SubMerchant.new(
      name: "Test Merchant",
      city: "Test City"
    )
    assert sub_merchant.valid?
  end
end
