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
  end

end
