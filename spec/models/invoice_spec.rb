require 'rails_helper'
require 'date'
RSpec.describe Invoice, type: :model do

  describe 'relationships' do
    it {should belong_to :customer}
    it {should have_many :invoice_items}
    it {should have_many :transactions}
    it {should have_many(:items).through(:invoice_items)}
    it {should have_many(:merchants).through(:items)}
  end

  it 'status can be in_progress' do
    invoice12 = Invoice.find(12)
    expect(invoice12.status).to eq("in_progress")
    expect(invoice12.cancelled?).to eq(false)
    expect(invoice12.completed?).to eq(false)
    expect(invoice12.in_progress?).to eq(true)
  end

  it 'status can be cancelled' do
    invoice29 = Invoice.find(29)
    expect(invoice29.status).to eq("cancelled")
    expect(invoice29.cancelled?).to eq(true)
    expect(invoice29.completed?).to eq(false)
    expect(invoice29.in_progress?).to eq(false)
  end

  it 'status can be completed' do
    invoice17 = Invoice.find(17)
    expect(invoice17.status).to eq("completed")
    expect(invoice17.cancelled?).to eq(false)
    expect(invoice17.completed?).to eq(true)
    expect(invoice17.in_progress?).to eq(false)
  end

  describe 'instance methods' do
    describe '#total_revenue' do
      it "gets sum of revenue for all invoice items on the invoice" do
        merchant = create(:merchant)
        item1 = create(:item, merchant_id: merchant.id)
        invoice = create(:invoice)
        invoice_item1 = create(:invoice_item, invoice_id: invoice.id, item_id: item1.id, quantity: 12, unit_price: 2)

        expect(invoice.total_revenue).to eq(24)
      end
      it "gets sum of revenue for all invoice items on the invoice with discounts" do
        merchant = create(:merchant)
        item1 = create(:item, merchant_id: merchant.id)
        invoice = create(:invoice)
        invoice_item1 = create(:invoice_item, invoice_id: invoice.id, item_id: item1.id ,quantity: 12, unit_price: 2)
        item2 = create(:item, merchant_id: merchant.id)
        invoice_item2 = create(:invoice_item, invoice_id: invoice.id, item_id: item2.id,quantity: 15, unit_price: 2)
        bulk_discount1 = create(:bulk_discount, merchant_id: merchant.id, percentage_discount: 20, quantity_threshold:13)

        expect(invoice.total_revenue).to eq(48)
      end
    end
  end
end
