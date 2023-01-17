class DiscountsController < ApplicationController 
  before_action :find_merchant, only: [:index, :new, :create, :destroy, :show, :edit, :update]
  def index
    @discounts = @merchant.discounts
    @upcoming_holidays = USHolidayService.new.get_next_public_holidays
  end

  def new
    
  end

  def create 
    discount = @merchant.discounts.new(permitted_params)

    if discount.save 
      redirect_to merchant_discounts_path(@merchant)
    else
      redirect_to new_merchant_discount_path(@merchant)
      flash[:alert] = 'Please fill in all fields!'
    end
  end

  def destroy 
    discount = @merchant.discounts.find(permitted_params[:id])
    discount.destroy
    redirect_to merchant_discounts_path(@merchant)
  end

  def show
    @discount = Discount.find(params[:id])
  end

  def edit 
    @discount = Discount.find(params[:id])
  end

  def update
    @discount = @merchant.discounts.find(permitted_params[:id])
    if @discount.update(permitted_params)
      redirect_to merchant_discount_path(@merchant, @discount)
    else
      redirect_to new_merchant_discount_path(@merchant)
      flash[:alert] = 'Please fill in all fields!'
    end
  end


  private 

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def permitted_params
    params.permit(:threshold, :percentage, :merchant_id, :id)
  end
end