require "sidekiq"
require "csv"

class CsvProcessJob
  include Sidekiq::Worker
  def perform(csv_data, bulk_id)
    CSV.parse(csv_data, headers: true) do |row|
      current_charge = row.to_hash
      charge = Charge.create!(
        bulk_id: bulk_id,
        sub_merchant_id: current_charge["sub_merchant_id"].to_s,
        amount: convert_amount(current_charge["charge_amount"].to_i),
        currency:  current_charge["charge_currency"].to_s,
      )
      Rails.logger.debug("--------------------")
      Rails.logger.debug("Charge created with ID: #{charge.id}")
      Rails.logger.debug("Charge amount: #{charge.amount}")
      ChargeJob.perform_later(current_charge, charge.id)
    end
    BulkStatusCheckJob.perform_in(5.seconds, bulk_id)
  end

  private
    def convert_amount(amount)
    converted = amount.to_f / 100.0
    Rails.logger.debug("Converted amount: #{converted}")
    converted
    end
end
