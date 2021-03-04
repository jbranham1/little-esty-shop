require 'rails_helper'

RSpec.describe 'Merchant Bulk Discounts Edit Page' do
  before :each do
    @merchant = Merchant.first
    @discount1 = create(:bulk_discount, merchant_id: @merchant.id)
  end

  describe "As a merchant," do
    describe "When I visit my merchant's bulk discounts edit page" do
      describe " I see a form to edit a bulk discount" do
        describe "When I fill in the form with valid data" do
          it "Then I am redirected back to the bulk discount show and I see my bulk discount updated" do
            visit edit_merchant_bulk_discount_path(@merchant, @discount1)
            expect(current_path).to eq("/merchant/#{@merchant.id}/bulk_discounts/#{@discount1.id}/edit")

            expect(page).to have_content("Edit Bulk Discount")
            fill_in 'bulk_discount[percentage_discount]', with: 30
            fill_in 'bulk_discount[quantity_threshold]', with: 10
            click_button 'Update Bulk discount'

            expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @discount1))
            expect(page).to have_content("Percentage Discount: 30")
            expect(page).to have_content("Quantity Threshold: 10")
          end
          describe "When I fill in the form with invalid data" do
            it "Then I am redirected back to the bulk discount edit page and see an error message" do
              visit edit_merchant_bulk_discount_path(@merchant, @discount1)
              expect(current_path).to eq("/merchant/#{@merchant.id}/bulk_discounts/#{@discount1.id}/edit")

              expect(page).to have_content("Edit Bulk Discount")
              fill_in 'bulk_discount[percentage_discount]', with: 'sdfsdf'
              click_button 'Update Bulk discount'
              expect(page).to have_content("Bulk Discount not updated: Percentage discount can't be blank and Quantity threshold can't be blank.")
              expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant, @discount1))
            end
          end
        end
      end
    end
  end
end
