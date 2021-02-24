class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions, dependent: :destroy
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items

  enum status: [:in_progress, :cancelled, :completed]

  def invoice_date
    created_at.strftime('%A, %B %d, %Y')
  end
end
