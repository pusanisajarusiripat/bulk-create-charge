class CreateBulks < ActiveRecord::Migration[7.2]
  def change
    create_table :bulks do |t|
      t.integer :amount_of_charges, null: false
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
