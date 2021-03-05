require 'rails_helper'

RSpec.describe 'Merchant Bulk Discounts Show Page' do
  before :each do
    @merchant = Merchant.first
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

      describe "Then I see a link to edit the bulk discount" do
        describe "When I click this link" do
          it "Then I am taken to a new page with a form to edit the discount" do
            visit merchant_bulk_discount_path(@merchant, @discount1)

            expect(page).to have_link("Edit Bulk Discount")
            click_link("Edit Bulk Discount")

            expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant, @discount1))
          end
        end
      end
    end
  end
end
