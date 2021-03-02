class Admin::MerchantsController < ApplicationController
  before_action :find_merchant, except: [:index, :new, :create]

  def index
    @facade = AdminMerchantsFacade.new
  end

  def show
  end

  def new
    @merchant = Merchant.new
  end

  def create
    @merchant = Merchant.new(merchants_params)

    if @merchant.save
      redirect_to "/admin/merchants/#{@merchant.id}"
    else
      flash[:errors] = @merchant.errors.full_messages
      render :new
    end
  end

  def edit
  end

  def update
    if params[:status]
      @merchant.update(merchants_params)
      flash[:success] = "#{@merchant.name} successfully updated"
      redirect_to "/admin/merchants"
    elsif @merchant.update(merchants_params)
      flash[:success] = "#{@merchant.name} successfully updated"
      redirect_to "/admin/merchants/#{@merchant.id}"
    else
      flash[:errors] = @merchant.errors.full_messages
      render :edit
    end
  end

  private

  def merchants_params
    params.permit(:name, :status)
  end

  def find_merchant
    @merchant = Merchant.find(params[:id])
  end
end
