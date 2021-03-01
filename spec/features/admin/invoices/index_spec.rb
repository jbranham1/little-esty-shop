require 'rails_helper'

RSpec.describe 'Admin Invoices Index Page' do
  before :each do
    @customers = Customer.all
    @invoices = Invoice.all
    @transactions = Transaction.all
    @merchants = Merchant.all
  end

  describe "As an admin, " do
    describe "When I visit the admin Invoices index" do
      it "Then I see a list of all Invoice ids as links to the admin show page" do
        visit admin_invoices_path

        expect(current_path).to eq ("/admin/invoices")
        expect(page).to have_content("Admin Invoices")
        expect(page).to have_content("Invoice ##{@invoices.first.id}")
        expect(page).to have_link("Invoice ##{@invoices.first.id}")
        expect(page).to have_content("Invoice ##{@invoices.last.id}")
        expect(page).to have_link("Invoice ##{@invoices.last.id}")
        click_on("Invoice ##{@invoices.first.id}")
        expect(current_path).to eq(admin_invoice_path(@invoices.first))
      end
    end
  end
end
