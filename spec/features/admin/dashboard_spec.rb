require 'rails_helper'

RSpec.describe 'Admin dashboard page' do
  before :each do
    @customers = Customer.all
    @invoices = Invoice.all
    @transactions = Transaction.all
    @merchants = Merchant.all
    visit "/admin"
  end
  describe "As a visitor" do
    describe "When I visit the admin dashboard (/admin)" do
      it "Then I see a header indicating that I am on the admin dashboard" do
        expect(page).to have_content("Admin Dashboard")
      end
      it 'Then I see a link to the admin merchants dashboard' do
        expect(page).to have_button("Admin Dashboard")

        click_button("Admin Dashboard")
        expect(current_path).to eq("/admin")
      end
      it 'Then I see a link to the admin merchants index (/admin/merchants)' do
        expect(page).to have_button("Merchants")

        click_button("Merchants")
        expect(current_path).to eq("/admin/merchants")
      end
      it 'And I see a link to the admin invoices index (/admin/invoices)' do
        expect(page).to have_button("Invoices")

        click_button("Invoices")
        expect(current_path).to eq("/admin/invoices")
      end
      describe 'Then I see the names of the top 5 customers who have conducted the largest number of successful transactions' do
        it "And next to each customer name I see the number of successful transactions they have conducted" do
          within ".top-customers" do
            expect(page).to have_content("Top Customers")
            expect(page).to have_content(@customers.top_5_customers_with_success.first.first_name)
            expect(page).to have_content(@customers.top_5_customers_with_success.first.last_name)
            expect(page).to have_content(@customers.top_5_customers_with_success.first.transaction_count)
          end
        end
      end
      describe "Then I see a section for Incomplete Invoices" do
        it 'I see a list of the ids of all invoices that have items that have not yet been shipped' do

          expect(page).to have_content("Incomplete Invoices")
          click_link("#{@invoices.incomplete_invoices.first.id}")
          expect(current_path).to eq("/admin/invoices/#{@invoices.incomplete_invoices.first.id}")

          visit "/admin"

          expect(page).to have_content("Incomplete Invoices")
          expect(page).to have_content(@invoices.incomplete_invoices.second.id)
          click_link("#{@invoices.incomplete_invoices.third.id}")
          expect(current_path).to eq("/admin/invoices/#{@invoices.incomplete_invoices.third.id}")
        end
        it "Next to each invoice id I see the date that the invoice was created formatted like Monday, July 18, 2019" do
          expect(page).to have_content(@invoices.incomplete_invoices.second.created_at.strftime('%A, %B %d, %Y'))
        end
      end
    end
  end
end
