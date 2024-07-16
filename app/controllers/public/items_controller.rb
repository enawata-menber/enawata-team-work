class Public::ItemsController < ApplicationController
    
    def index
        @items = Item.page(params[:page]).per(8)
        @item_count = Item.count
    end
    
    def show
         @item = Item.find(params[:id])
    end
end
