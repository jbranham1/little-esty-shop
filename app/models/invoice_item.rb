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
    revenue = unit_price * quantity
    discount = InvoiceItem.bulk_discount_by_item(:item_id)
    if discount.nil?
      revenue
    else
      revenue - (revenue * discount)
    end
  end

  def self.bulk_discount_by_item(item_id)
    joins(:bulk_discounts)
    .select('bulk_discounts.*')
    .where(item_id: item_id)
    .where('quantity >= quantity_threshold')
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
