class AdminController < ApplicationController
  def index
    @incomplete_invoices = InvoiceItem.incomplete_invoices
  end
end
