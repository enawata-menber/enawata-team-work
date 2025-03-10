class Admin::OrderDetailsController < ApplicationController
  before_action :authenticate_admin!

#  def update
#    @order_detail = OrderDetail.find(params[:id])
#    @order_detail.update(order_detail_params)
#    redirect_to admin_order_path(@order_detail.order)
#   end

# def update 
#     @order_detail = OrderDetail.find(params[:id])
#     @order = @order_detail.order
#     @order_details = @order.order_details.all
#   #@order_detail.update(order_detail_params)
    
#   is_updated = true
#     if @order_detail.update(order_detail_params)
#       @order.update(status: "making" ) if @order_detail.makings_status == "pending_production"
#       @order_details.each do |order_detail| 
#           if order_detail.makings_status != "completed"
#             is_updated = false 
#           end
#       end
#       @order.update(status: "preparing_shipment" ) if is_updated
#     end
#       redirect_to admin_order_path(@order)
# end



  
  # def update
  #   @order_detail = OrderDetail.find(params[:id])
  #   @order = @order_detail.order
  #   if @order_detail.update(order_detail_params)
  #     @order_detail.makings_status = "in_production"
  #     @order.update(status: :making)
  #   else
  #     @order_detail.makings_status = "completed"
  #     @order.update(status: :preparing_shipment)
  #   end
  #   redirect_to admin_order_path(@order)
  # end
  

  def update
    order_detail = OrderDetail.find(params[:id])
    order = order_detail.order
    order_detail.update(order_detail_params)
    if order.order_details.any? { |detail| detail.makings_status == "in_production" }
      order.update(status: "making")
    elsif order.order_details.all? { |detail| detail.makings_status == "completed" }
      order.update(status: "preparing_shipment")
    end
    redirect_to admin_order_path(order)
  end


  private
  def order_detail_params
    params.require(:order_detail).permit(:makings_status)
  end
end