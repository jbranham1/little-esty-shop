class DashboardController < ApplicationController
  before_action :find_merchant

  def index
    @top_5_customers_for_merchant = Customer.top_5_customers_by_merchant(params[:merchant_id])
    @items_ready_to_ship = Item.ready_to_ship_by_merchant(params[:merchant_id])
  end

  private

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end
