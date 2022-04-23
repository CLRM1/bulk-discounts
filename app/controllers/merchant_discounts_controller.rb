class MerchantDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:id])
  end

  def show
    @discount = BulkDiscount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:id])
  end

  def create
    @merchant = Merchant.find(params[:id])
    @merchant.bulk_discounts.create(percentage_discount: params[:percentage_discount],
                                    quantity_threshold: params[:quantity_threshold])
    @merchant.save
    redirect_to "/merchants/#{@merchant.id}/bulk_discounts"
  end

  def destroy
    @merchant = BulkDiscount.find(params[:id]).merchant
    BulkDiscount.destroy(params[:id])
    redirect_to "/merchants/#{@merchant.id}/bulk_discounts"
  end
end
