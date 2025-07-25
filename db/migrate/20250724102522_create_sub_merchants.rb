class CreateSubMerchants < ActiveRecord::Migration[7.2]
  def change
    create_table :sub_merchants do |t|
      t.string :name, null: false
      t.string :city, null: false

      t.timestamps
    end
  end
end
