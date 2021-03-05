require 'rails_helper'

RSpec.describe 'Merchant Bulk Discounts New Page' do
  before :each do
    BulkDiscount.destroy_all
    @merchant = Merchant.first
  end

  describe "As a merchant," do
    describe "When I visit my merchant's bulk discounts new page" do
      describe " I see a form to add a new bulk discount" do
        describe "When I fill in the form with valid data" do
          it "Then I am redirected back to the bulk discount index and I see my new bulk discount listed" do
            visit new_merchant_bulk_discount_path(@merchant)
            expect(current_path).to eq("/merchant/#{@merchant.id}/bulk_discounts/new")

            expect(page).to have_content("Create a New Bulk Discount")
            fill_in 'bulk_discount[percentage_discount]', with: 25
            fill_in 'bulk_discount[quantity_threshold]', with: 5
            click_button 'Create Bulk discount'

            expect(current_path).to eq(merchant_bulk_discounts_path(@merchant))
            within ".merchant-discounts" do
              expect(page).to have_content("Percentage Discount: 25")
              expect(page).to have_content("Quantity Threshold: 5")
            end
          end
          describe "When I fill in the form without percentage discount" do
            it "Then I am redirected back to the bulk discount new page and see an error message" do
              visit new_merchant_bulk_discount_path(@merchant)
              expect(current_path).to eq("/merchant/#{@merchant.id}/bulk_discounts/new")

              expect(page).to have_content("Create a New Bulk Discount")
              fill_in 'bulk_discount[quantity_threshold]', with: 5
              click_button 'Create Bulk discount'
              expect(page).to have_content("Bulk Discount not created: Percentage discount can't be blank and Percentage discount is not a number.")
              expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant))
            end
          end
          describe "When I fill in the form without quantity threshold" do
            it "Then I am redirected back to the bulk discount new page and see an error message" do
              visit new_merchant_bulk_discount_path(@merchant)
              expect(current_path).to eq("/merchant/#{@merchant.id}/bulk_discounts/new")

              expect(page).to have_content("Create a New Bulk Discount")
              fill_in 'bulk_discount[percentage_discount]', with: 25
              click_button 'Create Bulk discount'
              expect(page).to have_content("Bulk Discount not created: Quantity threshold can't be blank and Quantity threshold is not a number.")

              expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant))
            end
          end
        end
      end
    end
  end
end
