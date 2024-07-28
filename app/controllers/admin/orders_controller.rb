class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @orders = Order.all
  end
    
  def show
    @shipping_cost = 800
    @order = Order.find(params[:id])
    @order_details = @order.order_details
    @customer = @order.customer
  end
    
    
  def update
    @order = Order.find(params[:id])
    @order_details = @order.order_details
    @order.update(order_params)
  if @order.status == "confirm_payment"
     @order_details.update_all(makings_status: :pending_production)
  end
    redirect_to admin_order_path(@order)
  end
      
   private
    
  def order_params
     params.require(:order).permit(:status)
  end
end
