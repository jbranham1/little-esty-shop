require 'rails_helper'

RSpec.describe Item, type: :model do

  describe 'relationships' do
    it {should belong_to :merchant}
    it {should have_many :invoice_items}
    it {should have_many(:invoices).through(:invoice_items)}
  end

  describe 'validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :unit_price}
    it {should validate_numericality_of(:unit_price).is_greater_than_or_equal_to(0)}
  end

  it 'is created with status enabled when not provided' do
    cool = Merchant.create!(name: "Cool Beans")
    red = cool.items.create!(
            name: "Red Paint",
            description: "2 oz of red acrylic paint",
            unit_price: 8.99)

    expect(red.status).to eq("enabled")
    expect(red.enabled?).to eq(true)
    expect(red.disabled?).to eq(false)
  end

  it 'can have status disabled' do
    cool = Merchant.create!(name: "Cool Beans")
    red = cool.items.create!(
            name: "Red Paint",
            description: "2 oz of red acrylic paint",
            unit_price: 8.99)
    red.update!(status: :disabled)

    expect(red.status).to eq("disabled")
    expect(red.enabled?).to eq(false)
    expect(red.disabled?).to eq(true)
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
end
