class ItemsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @items = @merchant.items
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @item = Item.find(params[:id])
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @item = Item.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @item = Item.find(params[:id])

    if @item.update(item_params)
      @item.update!(item_params)
      flash[:notice] = "#{@item.name} successfully updated"
      render :show
    else
      flash[:errors] = @item.errors.full_messages
      render :edit
    end
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price, :status)
  end
end
