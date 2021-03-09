require 'rails_helper'

RSpec.describe 'Merchant Bulk Discounts Index Page' do
  before :each do
    @merchant = Merchant.first
    @discount1 = create(:bulk_discount, merchant_id: 1)
    @discount2 = create(:bulk_discount, merchant_id: 1)
    @discount3 = create(:bulk_discount, merchant_id: 2)
  end

  describe "As a merchant," do
    describe "When I visit my merchant's bulk discounts index (/merchants/merchant_id/bulk_discounts)" do
      describe "Then I see all of my bulk discounts with their discount and quantity thresolds" do
        it "And each bulk discount listed includes a link to its show page" do
          VCR.use_cassette('nager-date-next-public-holidays') do
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
      end
      describe "I see a section with a header of 'Upcoming Holidays'" do
        it "In this section the name and date of the next 3 upcoming US holidays are listed." do
          VCR.use_cassette('nager-date-next-public-holidays') do
            visit merchant_bulk_discounts_path(@merchant.id)

            within ".upcoming-holidays" do
              expect(page).to have_content("Upcoming Holidays")
            end
          end
        end
      end

      describe "Then I see a link to create a new discount" do
        describe "When I click this link" do
          it "Then I am taken to a new page where I see a form to add a new bulk discount" do
            VCR.use_cassette('nager-date-next-public-holidays') do
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
      describe "Then next to each bulk discount I see a link to delete it" do
        describe "When I click this link, then I am redirected back to the bulk discounts index page" do
          it "And I no longer see the discount listed" do
            VCR.use_cassette('nager-date-next-public-holidays-2') do
              merchant = create(:merchant)
              item1 = create(:item, merchant_id: merchant.id)
              invoice = create(:invoice)

              invoice_item1 = create(:invoice_item, invoice_id: invoice.id, item_id: item1.id, quantity: 10, unit_price: 2.5)
              bulk_discount1 = create(:bulk_discount, merchant_id: merchant.id, percentage_discount: 20, quantity_threshold:10)
              visit merchant_bulk_discounts_path(merchant.id)
                within ".discount-#{bulk_discount1.id}" do

                  expect(page).to have_button("Delete")
                  click_button "Delete"
                end
              expect(current_path).to eq(merchant_bulk_discounts_path(merchant.id))
              within ".merchant-discounts" do
                expect(page).to_not have_content(bulk_discount1.id)
              end
            end
          end
        end
        describe "Then next to each bulk discount I do not see a link to delete it" do
          it "because there are pending invoice items" do
            VCR.use_cassette('nager-date-next-public-holidays-2') do
              merchant = create(:merchant)
              item1 = create(:item, merchant_id: merchant.id)
              invoice = create(:invoice)

              invoice_item1 = create(:invoice_item, invoice_id: invoice.id, item_id: item1.id, quantity: 10, unit_price: 2.5, status: :pending)
              bulk_discount1 = create(:bulk_discount, merchant_id: merchant.id, percentage_discount: 20, quantity_threshold:10)
              visit merchant_bulk_discounts_path(merchant.id)
                within ".discount-#{bulk_discount1.id}" do

                  expect(page).to_not have_button("Delete")
                end
            end
          end
        end
      end
    end
  end
end
