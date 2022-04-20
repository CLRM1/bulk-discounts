class AdminMerchantsController < ApplicationController

  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  def edit
    @merchant = Merchant.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:id])
    merchant.name = params[:name]
    merchant.save
    redirect_to "/admin/merchants/#{merchant.id}"
  end

  def new

  end

  def create
    merchant = Merchant.new(merchant_params)
    merchant[:status] = 0
    merchant.save
    redirect_to "/admin/merchants"
  end

  private
  def merchant_params
    params.permit(:name)
  end
end
