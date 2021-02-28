require 'rails_helper'

RSpec.describe Item, type: :model do

  describe 'relationships' do
    it {should belong_to :merchant}
    it {should have_many :invoice_items}
    it {should have_many(:invoices).through(:invoice_items)}
    it {should have_many(:transactions).through(:invoices)}
    it {should have_many(:customers).through(:invoices)}
  end

  describe 'validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :unit_price}
    it {should validate_numericality_of(:unit_price).is_greater_than_or_equal_to(0)}
  end

  it 'is created with status disabled when not provided' do
    cool = Merchant.create!(name: "Cool Beans")
    red = cool.items.create!(
            name: "Red Paint",
            description: "2 oz of red acrylic paint",
            unit_price: 8.99)

    expect(red.status).to eq("disabled")
    expect(red.disabled?).to eq(true)
    expect(red.enabled?).to eq(false)
  end

  it 'can have status disabled' do
    cool = Merchant.create!(name: "Cool Beans")
    red = cool.items.create!(
            name: "Red Paint",
            description: "2 oz of red acrylic paint",
            unit_price: 8.99)
    red.update!(status: :enabled)

    expect(red.status).to eq("enabled")
    expect(red.disabled?).to eq(false)
    expect(red.enabled?).to eq(true)
  end

  describe 'class methods' do
    describe '::ready_to_ship_by_merchant' do
      it "gets items the have a status that isn't shipped for the merchant" do
        merchant = create(:merchant)
        item1 = create(:item, merchant_id: merchant.id)
        item2 = create(:item, merchant_id: merchant.id)
        invoice1 = create(:invoice)
        create(:invoice_item, item_id: item1.id, invoice_id: invoice1.id, status: :pending)
        create(:invoice_item, item_id: item2.id, invoice_id: invoice1.id, status: :pending)

        expect(Item.ready_to_ship_by_merchant(merchant.id).pluck(:name)).to eq([item1.name, item2.name])
      end
    end
  end

  describe "instance methods" do
    describe '#top_sales_day' do
      it "returns the date with most sales based on total_revenue for a item" do
        item = Merchant.first.items.where(id: 3).first
        invoice = item.invoices.where(id: 484).first

        expect(item.top_sales_day).to eq("#{invoice.created_at}")
      end
    end
  end
end
