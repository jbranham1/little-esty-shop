require 'rails_helper'

RSpec.describe 'Admin Invoices Show Page' do
  before :each do
    @invoice = Invoice.all.first
    @invoice_item = @invoice.invoice_items.first
    @merchant = @invoice_item.merchant
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
          expect(page).to have_content("Total Revenue: $1,016,156.00")
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
              expect(page).to have_content("$78,031.00")
              expect(page).to have_content(@invoice_item.status.titleize)
            end
          end
        end
        describe "I see the invoice status is a select field with the current invoice status" do
          describe "When I click this field I can select a new status and click 'Update Invoice Status'" do
            it "When I click this button, I am taken back to the same page and see the Invoice status updated" do
              merchant = create(:merchant)
              item1 = create(:item, merchant_id: merchant.id)
              invoice = create(:invoice)

              invoice_item1 = create(:invoice_item, invoice_id: invoice.id, item_id: item1.id, quantity: 10, unit_price: 2.5)
              bulk_discount1 = create(:bulk_discount, merchant_id: merchant.id, percentage_discount: 20, quantity_threshold:5)

              visit admin_invoice_path(invoice)
              invoice.update(status: :in_progress)
              expect(page.has_select?('invoice[status]', selected: :in_progress))
              select :cancelled, from: 'invoice[status]'
              click_button("Update Invoice")

              expect(current_path).to eq(admin_invoice_path(invoice))
              expect(invoice.invoice_items.first.discount_percentage).to eq(nil)
            end
            describe "When an Admin marks an invoice as “completed”," do
              it "then the discount percentage should be stored on the invoice item record so that it can be referenced later" do
                merchant = create(:merchant)
                item1 = create(:item, merchant_id: merchant.id)
                item2 = create(:item, merchant_id: merchant.id)
                invoice = create(:invoice)

                invoice_item1 = create(:invoice_item, invoice_id: invoice.id, item_id: item1.id, quantity: 10, unit_price: 2.5)
                invoice_item2 = create(:invoice_item, invoice_id: invoice.id, item_id: item2.id, quantity: 5, unit_price: 2.5)
                bulk_discount1 = create(:bulk_discount, merchant_id: merchant.id, percentage_discount: 20, quantity_threshold:10)
                visit admin_invoice_path(invoice)

                expect(page.has_select?('invoice[status]', selected: :in_progress))
                select :completed, from: 'invoice[status]'
                click_button("Update Invoice")

                expect(current_path).to eq(admin_invoice_path(invoice))
                expect(invoice.invoice_items.first.discount_percentage).to eq(20)
                expect(invoice.invoice_items.second.discount_percentage).to eq(nil)
              end
            end
          end
        end
      end
    end
  end
end
