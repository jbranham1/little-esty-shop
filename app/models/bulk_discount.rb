class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  has_many :items, through: :merchant
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  validates :percentage_discount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :quantity_threshold, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def self.bulk_discount_by_item(item_id)
    joins(:invoice_items)
    .select('count(invoice_items.item_id) as item_count, bulk_discounts.*')
    .group('invoice_items.item_id', :quantity_threshold, :percentage_discount, :id)
    .where('invoice_items.item_id': item_id)
    .having('bulk_discounts.quantity_threshold <= count(item_id)')
    .order('invoice_items.item_id', quantity_threshold: :desc)
    .first
  end
end
