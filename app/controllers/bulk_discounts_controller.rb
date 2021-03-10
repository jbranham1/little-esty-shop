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
      redirect_to new_merchant_bulk_discount_path(@merchant)
    end
  end

  def edit
    @discount = BulkDiscount.find(params[:id])
  end

  def update
    @discount = BulkDiscount.find(params[:id])
    if @discount.update(discount_params)
      flash[:notice] = "Bulk Discount #{@discount.id} successfully updated"
      render :show
    else
      flash[:errors] = "Bulk Discount not updated: #{@discount.errors.full_messages.to_sentence}."
      redirect_to edit_merchant_bulk_discount_path(@merchant, @discount)
    end
  end

  def destroy
    BulkDiscount.destroy(params[:id])
    redirect_to merchant_bulk_discounts_path(@merchant)
  end


  private

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def discount_params
    params[:bulk_discount].permit(:percentage_discount, :quantity_threshold)
  end
end
