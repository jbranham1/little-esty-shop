class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions, dependent: :destroy
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  enum status: [:in_progress, :cancelled, :completed]

  scope :incomplete_invoices, -> { includes(:invoice_items).where.not(status: 2).distinct.order(:created_at)}

  def total_revenue
    "$" + sprintf("%.2f", invoice_items.sum(&:revenue))
  end

  def distinct_status
    [:in_progress, :cancelled, :completed]
  end
end
