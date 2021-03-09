class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  has_many :items, through: :merchant
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  validates :percentage_discount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :quantity_threshold, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def pending_invoice_items_count
    invoice_items
    .where(status: :pending)
    .count
  end
end
