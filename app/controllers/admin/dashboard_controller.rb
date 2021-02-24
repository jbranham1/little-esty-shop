class Admin::DashboardController < ApplicationController

  def index
    @merchants = Merchant.all
    @invoices = Invoice.all
    @customers = Customer.all
  end
end
