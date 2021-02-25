require 'rails_helper'

RSpec.describe 'Merchant Invoices Index Page' do
  before :each do
    @merchant = Merchant.first
    @invoices = @merchant.invoices
  end

  describe "As a merchant," do
    describe "When I visit my merchant's invoices index (/merchants/merchant_id/invoices)" do
      describe "Then I see all of the invoices that include at least one of my merchant's items" do
        it "And for each invoice I see its id that links to the merchant_invoice_show_page" do
          visit merchant_invoices_path(@merchant.id)
          expect(current_path).to eq("/merchant/#{@merchant.id}/invoices")
          within ".invoice-#{@invoices.first.id}" do
            expect(page).to have_link(@invoices.first.id)
            expect(page).to_not have_link(@invoices.last.id)
            click_link "#{@invoices.first.id}"
            expect(current_path).to eq("/merchant/#{@merchant.id}/invoices/#{@invoices.first.id}")
          end
        end
      end
    end
  end
end
