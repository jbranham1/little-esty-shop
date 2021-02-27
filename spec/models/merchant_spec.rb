require 'rails_helper'

RSpec.describe Merchant, type: :model do

  describe 'relationships' do
    it {should have_many :items}
    it {should have_many(:invoice_items).through(:items)}
    it {should have_many(:invoices).through(:invoice_items)}
    it {should have_many(:transactions).through(:invoices)}
    it {should have_many(:customers).through(:invoices)}
  end

  describe 'validations' do
    it {should validate_presence_of :name}
  end

  it 'is created with status enabled when not provided' do
    cool = Merchant.create!(name: "Cool Beans")

    expect(cool.status).to eq("enabled")
    expect(cool.enabled?).to eq(true)
    expect(cool.disabled?).to eq(false)
  end

  it 'can have status disabled' do
    cool = Merchant.create!(name: "Cool Beans")
    cool.update!(status: :disabled)

    expect(cool.status).to eq("disabled")
    expect(cool.enabled?).to eq(false)
    expect(cool.disabled?).to eq(true)
  end

  describe 'instance methods' do
    describe '#distinct_invoices' do
      it "gets the distinct invoices for a merchant" do
        merchant = create(:merchant)
        item1 = create(:item, merchant_id: merchant.id)
        item2 = create(:item, merchant_id: merchant.id)
        invoice1 = create(:invoice)
        create(:invoice_item, item_id: item1.id, invoice_id: invoice1.id, status: :pending)
        create(:invoice_item, item_id: item2.id, invoice_id: invoice1.id, status: :pending)

        expect(merchant.distinct_invoices.pluck(:id)).to eq([invoice1.id])
      end
    end

    describe '#top_5_items' do
      it "returns the top 5 items based on total revenue for a merchant" do
        merchant = Merchant.first

        expect(merchant.top_5_items.first.name).to eq("Item Ea Voluptatum")
        expect(merchant.top_5_items.second.name).to eq("Item Quidem Suscipit")
        expect(merchant.top_5_items.third.name).to eq("Item Quo Magnam")
        expect(merchant.top_5_items.fourth.name).to eq("Item Expedita Fuga")
        expect(merchant.top_5_items.last.name).to eq("Item Rerum Est")
        expect(merchant.top_5_items.first.total_revenue).to eq(0.1938060e7)
        expect(merchant.top_5_items.last.total_revenue).to eq(0.255774e6)
      end
    end
  end
end
