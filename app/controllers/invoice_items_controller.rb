class InvoiceItemsController < ApplicationController
  def update
    invoice_item = InvoiceItem.find(params[:id])
    invoice_item.update(status: params[:invoice_item][:status])

    redirect_to "/merchant/#{params[:invoice_item][:merchant_id]}/invoices/#{params[:invoice_item][:invoice_id]}"
  end
end
