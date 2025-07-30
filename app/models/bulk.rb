class Bulk < ApplicationRecord
  has_one_attached :file
  has_many :charges, dependent: :destroy
  enum status: { pending: 0, in_process: 1, finished: 2, finished_with_error: 3 }
  validates :file, presence: true
  after_create_commit :create_charges_from_file

  private

  def create_charges_from_file
    Charge.create_from_csv(self.file, self)
  end
end
