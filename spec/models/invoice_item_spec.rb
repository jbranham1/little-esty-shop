require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do

  describe 'relationships' do
    it {should belong_to :item}
    it {should belong_to :invoice}
    it {should have_many(:transactions).through(:invoice)}
    it {should have_one(:merchant).through(:item)}
    it {should have_one(:customer).through(:invoice)}
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

end
