class BulkDiscountsController < ApplicationController
  before_action :find_merchant
  def index
    @facade = BulkDiscountIndexFacade.new(params[:merchant_id])
  end

  def show
    @discount = BulkDiscount.find(params[:id])
  end

  def new
  end

  def create
    @discount = @merchant.bulk_discounts.new(discount_params)
    if @discount.save
      redirect_to merchant_bulk_discounts_path(@merchant)
    else
      flash[:errors] = "Bulk Discount not created: #{@discount.errors.full_messages.to_sentence}."
      render :new
    end
  end

  def edit
  end

  def update
    if discount.update(discount_params)
      flash[:notice] = "#{discount.name}'s successfully updated"
      render :show
    else
      flash[:errors] = "Bulk Discount not updated: #{discount.errors.full_messages.to_sentence}."
      render :edit
    end
  end


  private

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def discount_params
    params[:bulk_discount].permit(:percentage_discount, :quantity_threshold)
  end
end
