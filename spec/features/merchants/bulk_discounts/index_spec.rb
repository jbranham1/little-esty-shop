require 'rails_helper'

RSpec.describe 'Merchant Bulk Discounts Index Page' do
  before :each do
    @merchant = Merchant.first
    @invoices = @merchant.invoices
    @discount1 = create(:bulk_discount, merchant_id: 1)
    @discount2 = create(:bulk_discount, merchant_id: 1)
    @discount3 = create(:bulk_discount, merchant_id: 2)
  end

  describe "As a merchant," do
    describe "When I visit my merchant's bulk discounts index (/merchants/merchant_id/bulk_discounts)" do
      describe "Then I see all of my bulk discounts with their discount and quantity thresolds" do
        it "And each bulk discount listed includes a link to its show page" do
          visit merchant_bulk_discounts_path(@merchant.id)
          expect(current_path).to eq("/merchant/#{@merchant.id}/bulk_discounts")
          within ".discount-#{@discount1.id}" do

            expect(page).to have_link("#{@discount1.id}")
            expect(page).to have_content("Percentage Discount: #{@discount1.percentage_discount}")
            expect(page).to have_content("Quantity Threshold: #{@discount1.quantity_threshold}")
            expect(page).to_not have_link("#{@discount3.id}")
            click_link "#{@discount1.id}"
            expect(current_path).to eq("/merchant/#{@merchant.id}/bulk_discounts/#{@discount1.id}")
          end
        end
      end
      describe "I see a section with a header of 'Upcoming Holidays'" do
        it "In this section the name and date of the next 3 upcoming US holidays are listed." do
          visit merchant_bulk_discounts_path(@merchant.id)
          within ".upcoming-holidays" do
            expect(page).to have_content("Upcoming Holidays")
          end
        end
      end

      describe "Then I see a link to create a new discount" do
        describe "When I click this link" do
          it "Then I am taken to a new page where I see a form to add a new bulk discount" do
            visit merchant_bulk_discounts_path(@merchant.id)
            within ".merchant-discounts" do
              expect(page).to have_link("Create New Bulk Discount")
              click_link("Create New Bulk Discount")

              expect(current_path).to eq (new_merchant_bulk_discount_path(@merchant))
            end
          end
        end
      end
    end
  end
end
