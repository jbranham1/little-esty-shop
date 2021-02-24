class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  validates_presence_of :name, :unit_price
  validates :unit_price, numericality: { greater_than_or_equal_to: 0 }

  enum status: [:enabled, :disabled]

  def self.ready_to_ship_by_merchant(merchant_id)
    joins(invoice_items: :invoice)
    .select('items.*, invoices.id as inv_id, invoices.created_at as invoice_date')
    .where('invoice_items.status <> 2')
    .where(items: {merchant_id: merchant_id})
    .order('invoices.created_at')
  end
end
