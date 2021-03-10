class Admin::InvoicesController < ApplicationController
  before_action :find_invoice, except: [:index]

  def index
    @invoices = Invoice.all
  end

  def show
  end

  def update
    @invoice.update(invoice_params)
    flash[:success] = "Invoice successfully updated"
    if @invoice.status == "completed"
      update_invoice_items_percentage
    end
    redirect_to "/admin/invoices/#{params[:id]}"
  end

  def update_invoice_items_percentage
    @invoice.invoice_items.each do |invoice_item|
      if !invoice_item.bulk_discount.nil?
        bulk_discount = invoice_item.bulk_discount.percentage_discount
        invoice_item.update(discount_percentage: bulk_discount)
        invoice_item.save
      end
    end
  end

  private

  def invoice_params
    params.require(:invoice).permit(:status)
  end

  def find_invoice
    @invoice = Invoice.find(params[:id])
  end
end
