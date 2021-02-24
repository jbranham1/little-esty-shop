class Customer < ApplicationRecord
  validates_presence_of :first_name, :last_name
  has_many :invoices, dependent: :destroy

  def full_name
     [self.first_name, self.last_name].join(' ')
  end

  def self.top_5_customers_with_success
    select('customers.first_name, customers.last_name, count(transactions.id) as transaction_count').joins(invoices: :transactions).where(transactions: {result: 0}).group(:id).order('transaction_count desc').limit(5)
  end

end
