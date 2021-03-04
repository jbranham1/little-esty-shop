require 'rails_helper'

RSpec.describe 'Merchant Bulk Discounts Show Page' do
  before :each do
    @merchant = Merchant.first
    @invoices = @merchant.invoices
    @discount1 = create(:bulk_discount, merchant_id: 1)
    @discount2 = create(:bulk_discount, merchant_id: 1)
    @discount3 = create(:bulk_discount, merchant_id: 2)
  end

  describe "As a merchant," do
    describe "When I visit my merchant's bulk discounts show page" do
        it "I see the Bulk discount and its information" do
          visit merchant_bulk_discount_path(@merchant, @discount1)
          expect(current_path).to eq("/merchant/#{@merchant.id}/bulk_discounts/#{@discount1.id}")

          expect(page).to have_content("#{@discount1.id}")
          expect(page).to have_content("Percentage Discount: #{@discount1.percentage_discount}")
          expect(page).to have_content("Quantity Threshold: #{@discount1.quantity_threshold}")
          expect(page).to_not have_content("#{@discount3.id}")
      end
    end
  end
end
