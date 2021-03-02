class InvoicesController < ApplicationController
  before_action :find_merchant

  def index
  end

  def show
    @invoice = Invoice.find(params[:id])
  end

  private

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end
