require 'rails_helper'

RSpec.describe 'Admin Invoices Show Page' do
  before :each do
    @invoice = Invoice.all.first
    @invoice_item = @invoice.invoice_items.first
    @customer = @invoice.customer
    @customer.update(address: '123 Main St', city: 'Denver', state: 'CO', zipcode: '80202')
    @customer.save
  end

  describe "As an admin, " do
    describe "When I visit the admin show page" do
      it "Then I see an invoice's id, status, and created_at date" do
        visit admin_invoice_path(@invoice)
        expect(current_path).to eq("/admin/invoices/#{@invoice.id}")

        expect(page).to have_content("Invoice ##{@invoice.id}")
        within ".invoice-information" do
          expect(page).to have_content("Created on: #{@invoice.created_at.strftime('%A, %B %d, %Y')}")
        end
      end
      it "And I see the total revenue that will be generated from all of my items on the invoice" do
        visit admin_invoice_path(@invoice)

        within ".invoice-information" do
          expect(page).to have_content("Total Revenue: #{@invoice.total_revenue}")
        end
      end
      it "Then I see the customer full name and address related to that invoice" do
        visit admin_invoice_path(@invoice)

        within ".invoice-customer" do
          expect(page).to have_content("Customer:")
          expect(page).to have_content(@customer.full_name)
          expect(page).to have_content(@customer.address)
          expect(page).to have_content("#{@customer.city}, #{@customer.state} #{@customer.zipcode}")
        end
      end
      describe "Then I see all of my items on the invoice including:" do
        it "Item name, The quantity of the item ordered, The price the Item sold for,The Invoice Item status" do

          visit admin_invoice_path(@invoice)

          within ".invoice-items" do
            expect(page).to have_content("Items on this Invoice:")

            within ".invoice-item-#{@invoice_item.id}" do
              expect(page).to have_content(@invoice_item.item.name)
              expect(page).to have_content(@invoice_item.quantity)
              expect(page).to have_content(@invoice_item.unit_price_dollar)
              expect(page).to have_content(@invoice_item.status.titleize)
            end
          end
        end
        describe "I see the invoice status is a select field with the current invoice status" do
          describe "When I click this field I can select a new status and click 'Update Invoice Status'" do
            it "When I click this button, I am taken back to the same page and see the Invoice status updated" do
              visit admin_invoice_path(@invoice)
              click_button("Update Invoice")
            end
          end
        end
      end
    end
  end
end
