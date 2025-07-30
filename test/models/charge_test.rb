require "test_helper"
include ActionDispatch::TestProcess

class ChargeTest < ActiveSupport::TestCase
  setup do
    @bulk = Bulk.create!(file: fixture_file_upload("bulk_create_test.csv", "text/csv"))
  end
  test "should not be valid (no params)" do
    charge = Charge.new
    assert_not charge.valid?
  end

  test "should be valid with amount and currency" do
    charge = @bulk.charges.create!(amount: 1000, currency: "THB")
    assert charge.valid?
  end

  test "should be decimal amount" do
    charge =  @bulk.charges.create!(amount: 1000.50, currency: "THB")
    assert_equal BigDecimal("1000.50"), charge.amount
  end

  test "should be created with correct amount" do
    charge = @bulk.charges.create!(amount: 1000.50, currency: "THB")
    assert_in_delta 1000.50, charge.amount.to_f, 0.001
  end
end
