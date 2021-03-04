class BulkDiscountsController < ApplicationController
  before_action :find_merchant
  def index
    @facade = BulkDiscountIndexFacade.new(params[:merchant_id])
  end

  def show
    @discount = BulkDiscount.find(params[:id])
  end

  private

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end
