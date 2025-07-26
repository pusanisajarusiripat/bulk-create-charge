require 'csv'

class Charge < ApplicationRecord
  belongs_to :bulk
  enum status: { pending: 0, in_process: 1, completed: 2, failed: 3, refunded: 4 }
  validates :amount, presence: true
  validates :currency, presence: true


  def self.create_from_csv(file, bulk)
    puts "Creating charges from CSV file: #{file} from bulk: #{bulk.id}"
    csv_data = file.download
    CSV.parse(csv_data, headers: true) do |row|
      current_charge = row.to_hash
      Charge.create!(
        bulk_id: bulk.id,
        sub_merchant_id: current_charge["sub_merchant_id"].to_s,
        amount: current_charge["charge_amount"].to_i,
        currency:  current_charge["charge_currency"].to_s,
      )
      # start background job to process the charge -> get token and create charges
    end
  end
end

