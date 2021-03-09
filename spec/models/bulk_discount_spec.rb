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

  describe 'instance methods' do
    describe '#pendinpending_invoice_itemsg_invoices' do
      describe "gets all pending invoice items for the bulk discount" do
        it "when there are pending invoices" do
          merchant = create(:merchant)
          item1 = create(:item, merchant_id: merchant.id)
          invoice = create(:invoice)

          invoice_item1 = create(:invoice_item, invoice_id: invoice.id, item_id: item1.id, quantity: 10, unit_price: 2.5, status: :pending)
          bulk_discount1 = create(:bulk_discount, merchant_id: merchant.id, percentage_discount: 20, quantity_threshold:10)

          expect(bulk_discount1.pending_invoice_items_count).to eq (1)
        end
        it "when there are not pending invoices" do
          merchant = create(:merchant)
          item1 = create(:item, merchant_id: merchant.id)
          invoice = create(:invoice)

          invoice_item1 = create(:invoice_item, invoice_id: invoice.id, item_id: item1.id, quantity: 10, unit_price: 2.5)
          bulk_discount1 = create(:bulk_discount, merchant_id: merchant.id, percentage_discount: 20, quantity_threshold:10)

          expect(bulk_discount1.pending_invoice_items_count).to eq (0)
        end
      end
    end
  end
end
