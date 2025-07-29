require "csv"

class Charge < ApplicationRecord
  belongs_to :bulk
  after_destroy :decrement_bulk_charge_count
  enum status: { pending: 0, in_process: 1, completed: 2, failed: 3, refunded: 4 }
  validates :amount, presence: true
  validates :currency, presence: true


  def self.create_from_csv(file, bulk)
    puts "Creating charges from CSV file: #{file} from bulk: #{bulk.id}"
    csv_data = file.download
    CSV.parse(csv_data, headers: true) do |row|
      current_charge = row.to_hash
      charge = Charge.create!(
        bulk_id: bulk.id,
        sub_merchant_id: current_charge["sub_merchant_id"].to_s,
        amount: convert_amount(current_charge["charge_amount"].to_i),
        currency:  current_charge["charge_currency"].to_s,
      )
      puts "--------------------"
      puts "Charge created with ID: #{charge.id}"
      puts "Charge amount: #{charge.amount}"
      ChargeJob.perform_async(current_charge, charge.id)
    end
  end


  private
    def decrement_bulk_charge_count
      bulk.decrement!(:amount_of_charges)
    end

    def self.convert_amount(amount)
      converted = amount.to_f / 100.0
      puts "Converted amount: #{converted}"
      converted
    end
end
