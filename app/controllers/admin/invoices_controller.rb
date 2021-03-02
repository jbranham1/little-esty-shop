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
    redirect_to "/admin/invoices/#{params[:id]}"
  end

  private

  def invoice_params
    params.require(:invoice).permit(:status)
  end

  def find_invoice
    @invoice = Invoice.find(params[:id])
  end
end
