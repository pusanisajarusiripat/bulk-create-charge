class Charge < ApplicationRecord
  belongs_to :bulk
  enum status: { pending: 0, in_process: 1, completed: 2, failed: 3, refunded: 4 }
  validates :amount, presence: true
  validates :currency, presence: true
end
