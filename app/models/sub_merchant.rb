class SubMerchant < ApplicationRecord
  belongs_to :merchant

  validates :name, presence: true
  validates :city, presence: true
end
