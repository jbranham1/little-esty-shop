require 'rails_helper'

RSpec.describe 'Admin Merchants Index Page' do
  before :each do
    @customers = Customer.all
    @invoices = Invoice.all
    @transactions = Transaction.all
    @merchants = Merchant.all
    visit "/admin/merchants"
  end

  it "test page contents" do

    expect(page).to have_content("Enabled Merchants")
    expect(page).to have_button("Enabled Merchants")
    click_button("Enabled Merchants")
  end

  it "test Enabled button" do
      click_button("Enabled Merchants")
      click_button("Enabled #{@merchants.first.id}")
  end

end
