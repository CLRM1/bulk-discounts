class MerchantsController < ApplicationController
  def show
    @merchant = Merchant.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:id])
    if params[:button] == 'true' && @merchant.status == "enabled"
      @merchant.status = "disabled"
    elsif params[:button] == 'true' && @merchant.status == "disabled"
      @merchant.status = "enabled"
    end
    @merchant.save
    redirect_to "/admin/merchants"
  end
end
