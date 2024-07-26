class Admin::OrdersController < ApplicationController
    before_action :authenticate_admin!

    def index
        @orders = Order.all
    end
    
    def show
        @order = Order.find(params[:id])
        @order_details = @order.order_details
    end
    
#    def update
#       @order = Order.find(params[:id])
#        @order.update(order_params)
#        @order_details = @order.order_details
#    
#        if @order.status == "入金確認"
#          @order_details.each do |order_detail|
#            order_detail.update(makings_status: 1 )
#          end
#        end
#        redirect_to admin_order_path(@order.id)
#    end
    
    # def update 
    #     @order = Order.find(params[:id])
    #     @order_details = @order.order_details
    # if  @order.update(order_params)
    #     @order_details.update_all(makings_status: "pending_production" ) if @order.status == "confirm_payment"
    # end
    #   redirect_to admin_order_path(@order)
    # end
    
      def update
          @order = Order.find(params[:id])
          @order_details = @order.order_details
          @order.update(order_params)
        # Check if the order status is changed to "payment_confirmed"
      if  @order.status == "confirm_payment"
        # Update all order details making status to "pending"
          @order_details.update_all(makings_status: :pending_production)
      end
          redirect_to admin_order_path(@order)
      end
      
   private
    
    def order_params
        params.require(:order).permit(:status)
    end
end
