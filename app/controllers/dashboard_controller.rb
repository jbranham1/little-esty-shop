class DashboardController < ApplicationController
  def index
    @facade = MerchantDashboardFacade.new(params[:merchant_id])
  end
end
