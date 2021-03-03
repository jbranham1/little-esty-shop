class Customer < ApplicationRecord
  validates_presence_of :first_name, :last_name

  has_many :invoices, dependent: :destroy
  has_many :invoice_items, through: :invoices
  has_many :transactions, through: :invoices
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  def full_name
     [first_name, last_name].join(' ')
  end

  def self.top_5_customers_with_success
    select('customers.*, count(transactions.id) as transaction_count').joins(:transactions).where(transactions: {result: 0}).group(:id).order('transaction_count desc').limit(5)
  end
end
