require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  describe 'relationships' do
    it {should belong_to :merchant}
    it {should have_many(:items).through(:merchant)}
    it {should have_many(:invoice_items).through(:items)}
    it {should have_many(:invoices).through(:invoice_items)}
    it {should have_many(:transactions).through(:invoices)}
    it {should have_many(:customers).through(:invoices)}
  end
  describe 'validations' do
    it {should validate_presence_of :percentage_discount}
    it {should validate_presence_of :quantity_threshold}
    it {should validate_numericality_of(:percentage_discount).is_greater_than_or_equal_to(0)}
    it {should validate_numericality_of(:quantity_threshold).is_greater_than_or_equal_to(0)}
  end
  describe 'class methods' do
    describe '::bulk_discount_by_item(item_id)' do
      it "bulk discount for item based on item count" do
        merchant = create(:merchant)
        item1 = create(:item, merchant_id: merchant.id)
        invoice1 = create(:invoice)
        invoice2 = create(:invoice)
        invoice3 = create(:invoice)
        invoice4 = create(:invoice)
        invoice_item1 = create(:invoice_item, invoice_id: invoice1.id, item_id: item1.id)
        invoice_item2 = create(:invoice_item, invoice_id: invoice2.id, item_id: item1.id)
        invoice_item3 = create(:invoice_item, invoice_id: invoice3.id, item_id: item1.id)
        invoice_item4 = create(:invoice_item, invoice_id: invoice4.id, item_id: item1.id)
        bulk_discount1 = create(:bulk_discount, merchant_id: merchant.id, percentage_discount: 25, quantity_threshold:2)
        bulk_discount2 = create(:bulk_discount, merchant_id: merchant.id, percentage_discount: 50, quantity_threshold:4)

        expect(BulkDiscount.bulk_discount_by_item(item1)[:percentage_discount]).to eq(50)
      end
    end
  end
end
