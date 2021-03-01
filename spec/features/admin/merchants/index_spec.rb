require 'rails_helper'

RSpec.describe 'Admin Merchants Index Page' do
  before :each do
    @customers = Customer.all
    @invoices = Invoice.all
    @transactions = Transaction.all
    @merchants = Merchant.all
    visit "/admin/merchants"
  end

  it "Can Create Merchant" do
    expect(page).to have_button("Create Merchant")
    click_button("Create Merchant")
    expect(current_path).to eq("/admin/merchants/new")
    fill_in :name, with: "Dev Rightorium"
    click_button("submit")
    expect(page).to have_content("Dev Rightorium")
  end

  it "Error not putting information to create " do
    expect(page).to have_button("Create Merchant")
    click_button("Create Merchant")
    expect(current_path).to eq("/admin/merchants/new")
    click_button("submit")
  end

  it "has top merchant name as link to merchant show page" do
    merchant = Merchant.find(14)
    within "#merchant-#{merchant.id}" do
      expect(page).to have_link(merchant.name)
      click_link(merchant.name)
      expect(current_path).to eq("/admin/merchants/#{merchant.id}")
    end
  end

  it "has ability to disable merchant" do
    merchant = Merchant.find(14)
    within "#en_merchant-#{merchant.id}" do
      expect(page).to have_button("Disabled")
      click_button("Disabled")
    end
  end

end
