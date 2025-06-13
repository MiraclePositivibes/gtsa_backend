class Transaction < ApplicationRecord
  belongs_to :user

  enum transaction_type: { debit: 0, credit: 1 }
  enum status: { pending: 0, processed: 1, failed: 2 }

  before_create :generate_reference_id

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :transaction_type, presence: true
  validates :status, presence: true

  def formatted_created_at
    created_at.strftime("%a, %b %d, %Y %I:%M %p")
  end

  # Add this to include formatted_created_at in JSON responses
  def as_json(options = {})
    super(options).merge(
      formatted_created_at: formatted_created_at
    )
  end

  private

  def generate_reference_id
    self.reference_id = SecureRandom.hex(12)
  end
end
