class ItemsController < ApplicationController
  before_action :find_merchant
  before_action :find_item, except: [:index, :new, :create]

  def index
  end

  def show
  end

  def edit
  end

  def update
    if @item.update(item_params)
      flash[:notice] = "#{@item.name}'s successfully updated"
      render :show
    else
      flash[:errors] = @item.errors.full_messages
      render :edit
    end
  end

  def new
    @item = Item.new
  end

  def create
    @item = @merchant.items.new(item_params)

    if @item.save
      redirect_to merchant_items_path(@merchant)
    else
      flash[:errors] = @item.errors.full_messages
      render :new
    end
  end

  private

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def find_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.permit(:name, :description, :unit_price)
  end
end
