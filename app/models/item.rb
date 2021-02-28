class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  validates_presence_of :name, :unit_price
  validates :unit_price, numericality: { greater_than_or_equal_to: 0 }

  enum status: [:disabled, :enabled]

  def self.ready_to_ship_by_merchant(merchant_id)
    joins(invoice_items: :invoice)
    .select('items.*, invoice_items.id as inv_item_id, invoices.id as inv_id, invoices.created_at as invoice_date')
    .where('invoice_items.status <> 2')
    .where(items: {merchant_id: merchant_id})
    .order('invoices.created_at')
  end

  def top_sales_date
    invoices
    .select('invoices.*, sum(invoice_items.quantity * invoice_items.unit_price) as total_revenues')
    .joins(:transactions)
    .where('transactions.result = ?', 1)
    .group('invoices.id')
    .order("total_revenues desc", "invoices.created_at desc")
    .first
    .created_at
  end
end
