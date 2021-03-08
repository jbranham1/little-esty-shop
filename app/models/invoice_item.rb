class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice
  has_many :transactions, through: :invoice
  has_one :merchant, through: :item
  has_one :customer, through: :invoice
  has_many :bulk_discounts, through: :merchant

  validates_presence_of :unit_price, :quantity
  validates :unit_price, :quantity, numericality: { greater_than_or_equal_to: 0 }
  enum status: [:pending, :packaged, :shipped]

  def revenue
    revenue = (unit_price * quantity).to_f
    revenue - (revenue * (self.bulk_discount.to_f/100))
  end

  def bulk_discount
    bulk_discounts
    .where('? >= quantity_threshold', self.quantity)
    .order(percentage_discount: :desc, quantity_threshold: :desc)
    .pluck(:percentage_discount)
    .first
  end

  def self.top_sales_date
    select('invoices.*, sum(invoice_items.quantity * invoice_items.unit_price) as total_revenues')
    .joins(:transactions)
    .where(transactions: {result: :success})
    .group('invoices.id')
    .order("total_revenues desc", "invoices.created_at desc")
    .first
    .created_at
  end
end
