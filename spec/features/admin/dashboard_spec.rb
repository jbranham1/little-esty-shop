require 'rails_helper'

RSpec.describe 'Admin dashboard page' do
  before :each do
    @jen = Merchant.create!(name: "Jen")
    @jewelry = @jen.items.create!(name: "Jewelry", description: "Shiny", unit_price: 10.50, status: "enabled")
  end

  it "Admin dashboard page contents" do
    visit "/admin"

    expect(page).to have_content("Admin Dashboard")
    expect(page).to have_button("Merchants")
    expect(page).to have_button("Invoices")
    expect(page).to have_content("Top Customers")
  end
end
