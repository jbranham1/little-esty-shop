class Customer < ApplicationRecord
  validates_presence_of :first_name, :last_name
  has_many :invoices, dependent: :destroy

  def self.top_customer_by_merchant(merchant_id)
    joins(invoices: [:transactions, :items])
    .select('customers.*, count(transactions.id) as transaction_count')
    .where(transactions: {result: 0})
    .where(items: {merchant_id: merchant_id})
    .group(:id)
    .order(transaction_count: :desc)
    .limit(5)
  end

  def full_name
    [first_name, last_name].join(' ')
  end
end
