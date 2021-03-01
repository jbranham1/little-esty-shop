require 'rails_helper'

RSpec.describe 'Merchant Invoices Show Page' do
  before :each do
    @merchant = Merchant.first
    @invoice = @merchant.invoices.first
    @invoice_item = @invoice.invoice_items.first
    @customer = @invoice.customer
    @customer.update(address: '123 Main St', city: 'Denver', state: 'CO', zipcode: '80202')
    @customer.save
  end
  describe "As a merchant," do
    describe "When I visit my merchant's invoice show page(/merchant/merchant_id/invoices/invoice_id)" do
      it "Then I see the invoice id, status, and created_at date" do
        visit merchant_invoice_path(@merchant.id, @invoice.id)
        expect(current_path).to eq("/merchant/#{@merchant.id}/invoices/#{@invoice.id}")

        expect(page).to have_content("Invoice ##{@invoice.id}")
        within ".invoice-information" do
          expect(page).to have_content("Status: #{@invoice.status.titleize}")
          expect(page).to have_content("Created on: #{@invoice.created_at.strftime('%A, %B %d, %Y')}")
        end
      end
      it "And I see the total revenue that will be generated from all of my items on the invoice" do
        visit merchant_invoice_path(@merchant.id, @invoice.id)

        within ".invoice-information" do
          expect(page).to have_content("Total Revenue: $1,281,794.00")
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
      describe "Then I see all of my items on the invoice including:" do
        it "Item name, The quantity of the item ordered, The price the Item sold for,The Invoice Item status" do

          visit merchant_invoice_path(@merchant.id, @invoice.id)

          within ".invoice-items" do
            expect(page).to have_content("Items on this Invoice:")

            within ".invoice-item-#{@invoice_item.id}" do
              expect(page).to have_content(@invoice_item.item.name)
              expect(page).to have_content(@invoice_item.quantity)
              expect(page).to have_content(@invoice_item.unit_price_dollar)
            end
          end
        end
        describe "I see that each invoice item status is a select field" do
          describe "And I see that the invoice item's current status is selected" do
            describe "When I click this select field, I can select a new Status" do
              it "And I can click 'Update Item Status' abd see that the item's status is updated" do
                visit merchant_invoice_path(@merchant.id, @invoice.id)

                within ".invoice-items" do
                  within ".invoice-item-#{@invoice_item.id}" do
                    expect(page).to have_content(@invoice_item.status)
                    expect(page).to have_button("Update Item Status")
                    #find(".dropdown-list")
                    #find(:css, '.dropdown-list').click_on(".a_different_dropdown")
                  #  fill_in :status, with: 'pending'
                  #  find("pending").click
                #    find(:select, from, options).find(:status, value, options).select_option
                  #  select "pending", :from => :status

                    #click_on 'Update Item Status'
                    #expect(page).to have_content("pending")
                  end
                  expect(current_path).to eq("/merchant/#{@merchant.id}/invoices/#{@invoice.id}")
                end
              end
            end
          end
        end
      end
    end
  end
end
