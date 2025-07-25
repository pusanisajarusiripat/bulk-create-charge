class AllowNullForAmountOfCharge < ActiveRecord::Migration[7.2]
  def change
    change_column_null :bulks, :amount_of_charges, true
  end
end
