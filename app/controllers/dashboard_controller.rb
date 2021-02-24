class DashboardController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @top_customers_for_merchant = Customer.top_customer_by_merchant(params[:merchant_id])
    @items_ready_to_ship = Item.ready_to_ship_by_merchant(params[:merchant_id])
  end
end
