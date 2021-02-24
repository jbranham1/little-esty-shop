require 'rails_helper'

RSpec.describe 'Admin dashboard page' do
  before :each do
    @jen = Merchant.create!(name: "Jen")
    @jewelry = @jen.items.create!(name: "Jewelry", description: "Shiny", unit_price: 10.50, status: "enabled")
  end

  it "Admin dashboard page contents" do
    visit "/admin"

    expect(page).to have_content("Admin Dashboard")
    expect(page).to have_link("Merchants")
    expect(page).to have_link("Invoices")
    expect(page).to have_content("Top 5 Customers with largest number of successful transactions")
  end
end
