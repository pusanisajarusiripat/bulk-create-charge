class ChargesController < ApplicationController
  def index
    @charges = Charge.all
  end

  def show
    @charge = Charge.find(params[:id])
  end

  def new
    @charge = Charge.new
  end

  def create
  end

  def destroy
    @charge = Charge.find(params[:id])
    if @charge.destroy
      redirect_to charge_path, notice: "Charge deleted successfully."
    else
      redirect_to charge_path, alert: "Failed to delete charge."
    end
  end
end
