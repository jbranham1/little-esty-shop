class MerchantItemsController < ApplicationController
  def update
    @merchant = Merchant.find(params[:merchant_id])
    @item = Item.find(params[:id])

    @item.update!(item_params)
    flash[:notice] = "#{@item.name}'s successfully updated"
    redirect_to merchant_items_path(@merchant)
  end

  private

  def item_params
    params.require(:item).permit(:status)
  end
end
