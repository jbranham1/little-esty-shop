class AdminDashboardFacade
  attr_reader :merchants,
              :invoices,
              :customers

  def initialize
    @merchants = Merchant.all
    @invoices = Invoice.all
    @customers = Customer.all
  end
end
