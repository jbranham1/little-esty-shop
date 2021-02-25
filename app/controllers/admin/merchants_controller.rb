class Admin::MerchantsController < ApplicationController

  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:id])
    if params[:status]
      merchant.update(merchants_params)
      flash[:success] = "Merchant successfully updated"
      redirect_to "/admin/merchants"
    elsif merchant.update(merchants_params)
      flash[:success] = "Merchant successfully updated"
      redirect_to "/admin/merchants/#{merchant.id}"
    else
      flash[:notice] = "Artist not created: Required information missing."
      render :edit
    end
  end

  def edit
    @merchant = Merchant.find(params[:id])
  end
end


  private
  def merchants_params
    params.permit(:name, :status)
  end
