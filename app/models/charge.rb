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
    bulk.update!(status: :in_process)
    CsvProcessJob.perform_async(csv_data, bulk.id)
  end

  private
    def decrement_bulk_charge_count
      bulk.decrement!(:amount_of_charges)
    end
end
