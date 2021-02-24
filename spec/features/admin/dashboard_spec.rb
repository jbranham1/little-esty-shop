require 'rails_helper'

RSpec.describe 'Admin dashboard page' do
  before :each do
    @customers = Customer.all
    @invoices = Invoice.all
    @transactions = Transaction.all
    @merchants = Merchant.all
    visit "/admin"
  end

  it "Admin dashboard page contents" do

    expect(page).to have_content("Admin Dashboard")
    expect(page).to have_button("Merchants")
    expect(page).to have_button("Invoices")
    expect(page).to have_content("Top Customers")

    expect(page).to have_content(@customers.top_5_customers_with_success.first.first_name)
    expect(page).to have_content(@customers.top_5_customers_with_success.first.last_name)
    expect(page).to have_content(@customers.top_5_customers_with_success.first.transaction_count)
  end

  it "test Admin Dashboard Button" do

    expect(page).to have_button("Admin Dashboard")
    click_button("Admin Dashboard")
    expect(current_path).to eq("/admin")
  end

  it "test Merchants Button" do

    expect(page).to have_button("Merchants")
    click_button("Merchants")
    expect(current_path).to eq("/admin/merchants")
  end

  it "test Invoices Button" do

    expect(page).to have_button("Invoices")
    click_button("Invoices")
    expect(current_path).to eq("/admin/invoices")
  end

  it "test Incomplete Invoices button and links" do

    expect(page).to have_button("Incomplete Invoices")
    click_button("Incomplete Invoices")
    click_link(@invoices.incomplete_invoices.first.id)
    expect(current_path).to eq("/admin/invoices/#{@invoices.incomplete_invoices.first.id}")

    visit "/admin"

    expect(page).to have_button("Incomplete Invoices")
    click_button("Incomplete Invoices")
    expect(page).to have_content(@invoices.incomplete_invoices.second.id)
    click_link(@invoices.incomplete_invoices.third.id)
    expect(current_path).to eq("/admin/invoices/#{@invoices.incomplete_invoices.third.id}")
  end
end
