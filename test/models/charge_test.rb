require "test_helper"

class ChargeTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess
  setup do
    @bulk = Bulk.create!(file: fixture_file_upload("bulk_create_test.csv", "text/csv"))
    @charge =  @bulk.charges.create!(amount: 1000.50, currency: "THB")
  end
  test "should not be valid (no params)" do
    charge = Charge.new
    assert_not charge.valid?
  end

  test "should be valid with amount and currency" do
    assert @charge.valid?
  end

  test "should be decimal amount" do
    assert_equal BigDecimal("1000.50"), @charge.amount
  end
end
