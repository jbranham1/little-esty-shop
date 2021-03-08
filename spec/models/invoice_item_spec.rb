require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do

  describe 'relationships' do
    it {should belong_to :item}
    it {should belong_to :invoice}
    it {should have_many(:transactions).through(:invoice)}
    it {should have_one(:merchant).through(:item)}
    it {should have_one(:customer).through(:invoice)}
    it {should have_many(:bulk_discounts).through(:merchant)}
  end

  describe 'validations' do
    it {should validate_presence_of :quantity}
    it {should validate_presence_of :unit_price}
    it {should validate_numericality_of(:unit_price).is_greater_than_or_equal_to(0)}
    it {should validate_numericality_of(:quantity).is_greater_than_or_equal_to(0)}
  end

  it 'status can be pending' do
    @invoice_items = InvoiceItem.all
    expect(@invoice_items.first.status).to eq("pending")
    expect(@invoice_items.first.pending?).to eq(true)
    expect(@invoice_items.first.packaged?).to eq(false)
    expect(@invoice_items.first.shipped?).to eq(false)
  end

  it 'status can be packaged' do
    @invoice_items = InvoiceItem.all
    expect(@invoice_items.second.status).to eq("packaged")
    expect(@invoice_items.second.pending?).to eq(false)
    expect(@invoice_items.second.packaged?).to eq(true)
    expect(@invoice_items.second.shipped?).to eq(false)
  end

  it 'status can be shipped' do
    @invoice_item84 = InvoiceItem.find(84)
     expect(@invoice_item84.status).to eq("shipped")
     expect(@invoice_item84.pending?).to eq(false)
     expect(@invoice_item84.packaged?).to eq(false)
     expect(@invoice_item84.shipped?).to eq(true)
  end

  describe 'class methods' do
    describe '::top_sales_date' do
      it "returns the date with most sales based on total_revenue" do
        @invoice = Invoice.find(323)
        expect(InvoiceItem.top_sales_date).to eq(@invoice.created_at)
      end
    end
  end

  describe 'instance methods' do
    describe '#revenue' do
      describe "gets revenue of invoice item" do
        it "when there is no bulk discount" do
          BulkDiscount.destroy_all
          invoice_item = create(:invoice_item, unit_price: 2.5, quantity: 3, id: 1000)

          expect(invoice_item.revenue).to eq(7.5)
        end
        it "when there is a bulk discount" do
          merchant = create(:merchant)
          item1 = create(:item, merchant_id: merchant.id)
          invoice = create(:invoice)

          invoice_item1 = create(:invoice_item, invoice_id: invoice.id, item_id: item1.id, quantity: 10, unit_price: 2.5)
          bulk_discount1 = create(:bulk_discount, merchant_id: merchant.id, percentage_discount: 20, quantity_threshold:10)

          expect(invoice_item1.revenue).to eq(20)
        end
      end
    end

    describe '#bulk_discount' do
      describe "bulk discount for item based on item count" do
        describe "Merchant A has one Bulk Discount, Bulk Discount A is 20% off 10 items," do
          describe "Invoice A includes two of Merchant A’s items, Item A is ordered in a quantity of 5, Item B is ordered in a quantity of 5" do
            it "No bulk discounts should be applied." do
              merchant = create(:merchant)
              item1 = create(:item, merchant_id: merchant.id)
              invoice = create(:invoice)

              invoice_item1 = create(:invoice_item, invoice_id: invoice.id, item_id: item1.id, quantity: 5)

              item2 = create(:item, merchant_id: merchant.id)
              invoice_item2 = create(:invoice_item, invoice_id: invoice.id, item_id: item2.id, quantity: 5)

              bulk_discount1 = create(:bulk_discount, merchant_id: merchant.id, percentage_discount: 20, quantity_threshold:10)
              expect(invoice_item1.bulk_discount).to eq(nil)
              expect(invoice_item2.bulk_discount).to eq(nil)
            end
          end
        end
        describe "Merchant A has one Bulk Discount, Bulk Discount A is 20% off 10 items," do
          describe "Invoice A includes two of Merchant A’s items, Item A is ordered in a quantity of 10, Item B is ordered in a quantity of 5" do
            it "Item A should be discounted at 20% off. Item B should not be discounted." do
              merchant = create(:merchant)
              item1 = create(:item, merchant_id: merchant.id)
              invoice = create(:invoice)

              invoice_item1 = create(:invoice_item, invoice_id: invoice.id, item_id: item1.id, quantity: 10)
              item2 = create(:item, merchant_id: merchant.id)

              invoice_item2 = create(:invoice_item, invoice_id: invoice.id, item_id: item2.id, quantity: 5)
              bulk_discount1 = create(:bulk_discount, merchant_id: merchant.id, percentage_discount: 20, quantity_threshold:10)
              expect(invoice_item1.bulk_discount).to eq(20)
              expect(invoice_item2.bulk_discount).to eq(nil)
            end
          end
        end
        describe "Merchant A has two Bulk Discounts, Bulk Discount A is 20% off 10 items, Bulk Discount B is 30% off 15 items" do
          describe "Invoice A includes two of Merchant A’s items, Item A is ordered in a quantity of 12, Item B is ordered in a quantity of 15" do
            it "Item A should discounted at 20% off, and Item B should discounted at 30% off." do
              merchant = create(:merchant)
              item1 = create(:item, merchant_id: merchant.id)
              invoice = create(:invoice)

              invoice_item1 = create(:invoice_item, invoice_id: invoice.id, item_id: item1.id ,quantity: 12)

              item2 = create(:item, merchant_id: merchant.id)

              invoice_item2 = create(:invoice_item, invoice_id: invoice.id, item_id: item2.id,quantity: 15)

              bulk_discount1 = create(:bulk_discount, merchant_id: merchant.id, percentage_discount: 20, quantity_threshold:10)
              bulk_discount2 = create(:bulk_discount, merchant_id: merchant.id, percentage_discount: 30, quantity_threshold:15)
              expect(invoice_item1.bulk_discount).to eq(20)
              expect(invoice_item2.bulk_discount).to eq(30)
            end
          end
        end
        describe "Merchant A has two Bulk Discounts, Bulk Discount A is 20% off 10 items, Bulk Discount B is 15% off 15 items" do
          describe "Invoice A includes two of Merchant A’s items, Item A is ordered in a quantity of 12, Item B is ordered in a quantity of 15" do
            it "Both Item A and Item B should discounted at 20% off. " do
              merchant = create(:merchant)
              item1 = create(:item, merchant_id: merchant.id)
              invoice = create(:invoice)

              invoice_item1 = create(:invoice_item, invoice_id: invoice.id, item_id: item1.id, quantity: 12)
              item2 = create(:item, merchant_id: merchant.id)

              invoice_item2 = create(:invoice_item, invoice_id: invoice.id, item_id: item2.id, quantity: 15)

              bulk_discount1 = create(:bulk_discount, merchant_id: merchant.id, percentage_discount: 20, quantity_threshold:10)
              bulk_discount2 = create(:bulk_discount, merchant_id: merchant.id, percentage_discount: 15, quantity_threshold:15)
              expect(invoice_item1.bulk_discount).to eq(20)
              expect(invoice_item2.bulk_discount).to eq(20)
            end
          end
        end
        describe "Merchant A has two Bulk Discounts, Bulk Discount A is 20% off 10 items,Bulk Discount B is 30% off 15 items, Merchant B has no discounts" do
          describe "Invoice A includes two of Merchant A’s items, Item A1 is ordered in a quantity of 12,Item A2 is ordered in a quantity of 15" do
            describe "Invoice A also includes one of Merchant B’s items, Item B is ordered in a quantity of 15" do
              it "Item A1 should discounted at 20% off, and Item A2 should discounted at 30% off. Item B should not be discounted." do
                merchant = create(:merchant)
                merchant2 = create(:merchant)
                item1 = create(:item, merchant_id: merchant.id)
                invoice = create(:invoice)

                invoice_item1 = create(:invoice_item, invoice_id: invoice.id, item_id: item1.id, quantity: 12)

                item2 = create(:item, merchant_id: merchant.id)
                invoice_item2 = create(:invoice_item, invoice_id: invoice.id, item_id: item2.id, quantity: 15)

                item3 = create(:item, merchant_id: merchant2.id)
                invoice_item3 = create(:invoice_item, invoice_id: invoice.id, item_id: item3.id, quantity: 15)

                bulk_discount1 = create(:bulk_discount, merchant_id: merchant.id, percentage_discount: 20, quantity_threshold:10)
                bulk_discount2 = create(:bulk_discount, merchant_id: merchant.id, percentage_discount: 15, quantity_threshold:30)
                expect(invoice_item1.bulk_discount).to eq(20)
                expect(invoice_item2.bulk_discount).to eq(20)
                expect(invoice_item3.bulk_discount).to eq(nil)
              end
            end
          end
        end
      end
    end
  end
end
