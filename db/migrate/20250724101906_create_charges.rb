class CreateCharges < ActiveRecord::Migration[7.2]
  def change
    create_table :charges do |t|
      t.string :charge_id
      t.references :bulk, null: false, foreign_key: true
      t.references :sub_merchant, foreign_key: true
      t.integer :amount, null: false
      t.string :currency, null: false
      t.integer :status, null: false, default: 0
      t.text :charge_API_response
      t.text :token_API_response
      t.string :capture_at
      t.timestamps
    end
  end
end
