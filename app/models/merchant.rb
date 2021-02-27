class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  validates_presence_of :name

  enum status: [:enabled, :disabled]

  after_initialize :default

  def default
    self.status == "disabled"
  end

  def distinct_invoices
    invoices.distinct
  end

  def top_5_items
    items
    .joins(invoices: :transactions)
    .select('items.*, sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue')
    .where('transactions.result = ?', 1)
    .group('items.id')
    .order(total_revenue: :desc)
    .limit(5)
  end
end
