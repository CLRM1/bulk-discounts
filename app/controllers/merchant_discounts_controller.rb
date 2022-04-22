class MerchantDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:id])
  end

  def show
    @merchant = BulkDiscount.find(params[:id])
  end
end
