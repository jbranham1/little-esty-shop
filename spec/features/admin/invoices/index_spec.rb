require 'rails_helper'

RSpec.describe 'Admin Invoices Index Page' do
  before :each do
    @customers = Customer.all
    @invoices = Invoice.all
    @transactions = Transaction.all
    @merchants = Merchant.all
    visit "/admin/invoices"
  end

end
