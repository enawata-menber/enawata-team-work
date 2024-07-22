class Admin::OrdersController < ApplicationController
    def index
        @order = current_customer.orders
    end
end
