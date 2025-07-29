class ChangeAmountType < ActiveRecord::Migration[7.2]
  def up
    change_column :charges, :amount, :float
  end

  def down
    change_column :charges, :amount, :integer, null: false
  end
end
