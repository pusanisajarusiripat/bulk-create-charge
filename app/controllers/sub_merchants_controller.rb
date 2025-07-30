class SubMerchantsController < ApplicationController
  def index
    @sub_merchants = SubMerchant.all
  end

  def show
    @sub_merchant = SubMerchant.find(params[:id])
  end

  def new
    @sub_merchant = SubMerchant.new
  end

  def create
    @sub_merchant = SubMerchant.new(sub_merchant_params)
    if @sub_merchant.save
      redirect_to sub_merchant_path(@sub_merchant), notice: "Submerchant created successfully."
    else
      render :new, alert: "Failed to create submerchant."
    end
  end

  def edit
    @sub_merchant = SubMerchant.find(params[:id])
  end

  def update
    @sub_merchant = SubMerchant.find(params[:id])
    if @sub_merchant.update(sub_merchant_params)
      redirect_to sub_merchant_path(@sub_merchant), notice: "Submerchant updated successfully."
    else
      render :edit, alert: "Failed to update submerchant."
    end
  end

  def destroy
    @sub_merchant = SubMerchant.find(params[:id])
    if @sub_merchant.destroy
      redirect_to charge_path, notice: "Submerchant deleted successfully."
    else
      redirect_to charge_path, alert: "Failed to delete submerchant."
    end
  end

  private
  def sub_merchant_params
    params.require(:sub_merchant).permit(:name, :city)
  end
end
