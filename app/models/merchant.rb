class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  validates_presence_of :name

  enum status: [:disabled, :enabled]


  # scope :top_merchants, -> {select('merchants.*,sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue').joins(items: [{invoice_items: :invoice}, :transactions]).where(transactions: {result: :success}).group(:id).order('total_revenue desc').limit(5)}

  def top_sales_date
    invoices.joins(:transactions).where(transactions: {result: 0}).select('invoices.*,count(invoice_items.id) as invoice_items_count').group(:id).order('invoice_items_count desc').first.created_at
  end

  def self.top_5_by_revenue
    select('merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue')
    .joins(items: [{invoice_items: :invoice}, :transactions])
    .where(transactions: {result: :success})
    .group(:id)
    .order('total_revenue desc')
    .limit(5)
  end

  def distinct_invoices
    invoices.distinct
  end

  def top_5_items
    items
    .select('items.*, sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue')
    .joins(invoices: :transactions)
    .where(transactions: {result: :success})
    .group('items.id')
    .order(total_revenue: :desc)
    .limit(5)
  end
end
