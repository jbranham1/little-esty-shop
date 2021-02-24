require 'rails_helper'

RSpec.describe 'Merchant Dashboard' do
  before :each do
    @merchant = create(:merchant)
  end
  describe "As a merchant," do
    describe "When I visit my merchant dashboard (/merchant/merchant_id/dashboard)" do
      it "Then I see the name of my merchant" do
        visit merchant_dashboard_index_path(@merchant.id)

        expect(current_path).to eq("/merchant/#{@merchant.id}/dashboard")
        expect(page).to have_content(@merchant.name)
      end
      it "Then I see link to my merchant items index (/merchant/merchant_id/items)" do
        visit merchant_dashboard_index_path(@merchant.id)

        expect(page).to have_button('My Items')
        click_on ('My Items')
        expect(current_path).to eq("/merchant/#{@merchant.id}/items")
      end
      it "And I see a link to my merchant invoices index (/merchant/merchant_id/invoices)" do
        visit merchant_dashboard_index_path(@merchant.id)

        expect(page).to have_button('My Invoices')
        click_on ('My Invoices')
        expect(current_path).to eq("/merchant/#{@merchant.id}/invoices")
      end
      it "Then I see the names of the top 5 customers
        who have conducted the largest number of successful transactions with my merchant
        And next to each customer name I see the number of successful transactions they have
        conducted with my merchant" do
      end
      describe "Then I see a section for 'Items Ready to Ship'" do
        it "In that section I see a list of the item names that have been ordered but not shipped" do
          merchant = create(:merchant)
          item1 = create(:item, merchant_id: merchant.id)
          item2 = create(:item, merchant_id: merchant.id)
          invoice1 = create(:invoice)
          create(:invoice_item, item_id: item1.id, invoice_id: invoice1.id, status: :pending)
          create(:invoice_item, item_id: item2.id, invoice_id: invoice1.id, status: :pending)

          visit merchant_dashboard_index_path(merchant.id)

          expect(page).to have_content("Items Ready to Ship")
          expect(page).to have_content("#{item1.name} - Invoice #{invoice1.id} - #{invoice1.created_at.strftime('%A, %B %d, %Y')}")
        end
        it "And next to each Item I see the id of the invoice that ordered my item and each invoice id is a link to my merchant's invoice show page" do
        end
        it "Next to each Item name I see the date that the invoice was created and I see the date formatted like 'Monday, July 18, 2019'" do
        end
        it "I see that the list is ordered from oldest to newest" do
        end
      end
    end
  end
end
