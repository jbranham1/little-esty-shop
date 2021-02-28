require 'rails_helper'

RSpec.describe 'Admin Merchants Show Page' do
  before :each do
    @customers = Customer.all
    @invoices = Invoice.all
    @transactions = Transaction.all
    @merchants = Merchant.all
    visit "/admin/merchants/#{@merchants.first.id}"
  end

  it "test page contents" do

    expect(page).to have_content(@merchants.first.name)
    expect(page).to have_content("Admin Dashboard")
    expect(page).to have_button("Admin Dashboard")
  end
  
  it "Test Update button and can update" do

    expect(page).to have_button("Update Merchant")
    click_button("Update Merchant")
    expect(current_path).to eq("/admin/merchants/#{@merchants.first.id}/edit")
    fill_in :name, with: "Leftorium"

    click_button("submit")
    expect(current_path).to eq("/admin/merchants/#{@merchants.first.id}")
    expect(page).to have_content("Leftorium")
  end
end
