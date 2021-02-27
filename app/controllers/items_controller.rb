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
      flash[:notice] = "#{@item.name} successfully updated"
      render :show
    else
      flash[:errors] = @item.errors.full_messages
      render :edit
    end
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @item = @merchant.items.new(item_params)
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @item = @merchant.items.new(item_params)
    
    if @item.save
      redirect_to merchant_items_path(@merchant)
    else
      flash[:errors] = @item.errors.full_messages
      render :new
    end
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price, :status)
  end
end
