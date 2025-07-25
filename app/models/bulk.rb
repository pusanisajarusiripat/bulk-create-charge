class Bulk < ApplicationRecord
  has_one_attached :file
  has_many :charges, dependent: :destroy
  enum status: { pending: 0, in_process: 1, finished: 2, finised_with_error: 3 }
end
