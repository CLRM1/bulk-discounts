class AdminController < ApplicationController
  def index
    @incomplete_invoices = InvoiceItem.incomplete_invoices
    @merchant = Merchant.first
  end
end
