require 'rails_helper'
require 'date'
RSpec.describe Invoice, type: :model do

  describe 'relationships' do
    it {should belong_to :customer}
    it {should have_many :invoice_items}
    it {should have_many :transactions}
    it {should have_many(:items).through(:invoice_items)}
  end

  it 'status can be 0 by default' do
    invoice = create(:invoice, status: :in_progress)
    expect(invoice.status).to eq("in_progress")
    expect(invoice.cancelled?).to eq(false)
    expect(invoice.completed?).to eq(false)
    expect(invoice.in_progress?).to eq(true)
  end

  it 'status can be cancelled' do
    invoice = create(:invoice, status: :cancelled)
    expect(invoice.status).to eq("cancelled")
    expect(invoice.cancelled?).to eq(true)
    expect(invoice.completed?).to eq(false)
    expect(invoice.in_progress?).to eq(false)
  end

  it 'status can be completed' do
    invoice = create(:invoice, status: :completed)
    expect(invoice.status).to eq("completed")
    expect(invoice.cancelled?).to eq(false)
    expect(invoice.completed?).to eq(true)
    expect(invoice.in_progress?).to eq(false)
  end

  describe 'instance methods' do
    describe '::invoice_date' do
      it 'formats the invoice date' do
        invoice = create(:invoice, created_at: Date.new(2021,02,24))

        expect(invoice.invoice_date).to eq("Wednesday, February 24, 2021")
      end
    end
  end
end
