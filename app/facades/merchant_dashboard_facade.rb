class MerchantDashboardFacade
  attr_reader :merchant,
              :top_5_customers_for_merchant,
              :items_ready_to_ship

  def initialize(merchant_id)
    @merchant = Merchant.find(merchant_id)
    @top_5_customers_for_merchant = @merchant.top_5_customers_by_transactions
    @items_ready_to_ship = Item.ready_to_ship_by_merchant(merchant_id)
  end
end
