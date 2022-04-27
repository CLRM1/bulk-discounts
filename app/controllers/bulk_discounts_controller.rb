class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @holidays = HolidayFacade.new.holidays
  end

  def show
    @discount = BulkDiscount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @merchant.bulk_discounts.create(percentage_discount: params[:percentage_discount],
                                    quantity_threshold: params[:quantity_threshold])
    @merchant.save
    redirect_to "/merchants/#{@merchant.id}/bulk_discounts"
  end

  def edit
    @discount = BulkDiscount.find(params[:id])
  end

  def update
    discount = BulkDiscount.find(params[:id])
    merchant = discount.merchant

    if discount.update(merchant_discounts_params)
      redirect_to "/merchants/#{merchant.id}/bulk_discounts/#{discount.id}"
    else
      redirect_to "/merchants/#{merchant.id}/bulk_discounts/#{discount.id}/edit"
      flash[:notice] = "Error: please fill in all required fields."
    end
  end

  def destroy
    @merchant = BulkDiscount.find(params[:id]).merchant
    BulkDiscount.destroy(params[:id])
    redirect_to "/merchants/#{@merchant.id}/bulk_discounts"
  end

  private

  def merchant_discounts_params
    params.permit(:percentage_discount, :quantity_threshold)
  end
end
