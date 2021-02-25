require 'rails_helper'

RSpec.describe 'Merchant Invoices Show Page' do
  before :each do
    @merchant = Merchant.first
    @invoice = @merchant.invoices.first
    @customer = @invoice.customer
    @customer.update(address: '123 Main St', city: 'Denver', state: 'CO', zipcode: '80202')
    @customer.save
  end
  describe "As a merchant," do
    describe "When I visit my merchant's invoice show page(/merchants/merchant_id/invoices/invoice_id)" do
      it "Then I see the invoice id, status, and created_at date" do
        visit merchant_invoice_path(@merchant.id, @invoice.id)
        expect(current_path).to eq("/merchants/#{@merchant.id}/invoices/#{@invoice.id}")

        expect(page).to have_content("Invoice ##{@invoice.id}")
        within ".invoice-information" do
          expect(page).to have_content("Status: #{@invoice.status.titleize}")
          expect(page).to have_content("Created on: #{@invoice.created_at.strftime('%A, %B %d, %Y')}")
        end
      end
      it "Then I see all of the customer information related to that merchant" do
        visit merchant_invoice_path(@merchant.id, @invoice.id)

        within ".invoice-customer" do
          expect(page).to have_content("Customer:")
          expect(page).to have_content(@customer.full_name)
          expect(page).to have_content(@customer.address)
          expect(page).to have_content("#{@customer.city}, #{@customer.state} #{@customer.zipcode}")
        end
      end
    end
  end
end
