require "test_helper"
include ActionDispatch::TestProcess

class BulkTest < ActiveSupport::TestCase
  setup do
    @bulk = Bulk.create!(file: fixture_file_upload("bulk_create_test.csv", "text/csv"))
  end
  test "should be valid" do
    bulk = Bulk.new
    assert_not bulk.valid?
  end

  test "bulk should have a file attached" do
    assert @bulk.valid?
  end

  test "bulk should not be valid without a file" do
    bulk = Bulk.new
    assert_not bulk.valid?
  end

  test "charges should be deleted if bulk is deleted" do
    charge = @bulk.charges.create!(amount: 1000, currency: "THB")
    assert_difference("Charge.count", -1) do
      @bulk.destroy
    end
  end
end
