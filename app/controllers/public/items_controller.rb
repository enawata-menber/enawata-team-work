class Public::ItemsController < ApplicationController
   before_action :authenticate_customer
    
    def index
        # @items = Item.where(is_active: true).page(params[:page]).per(8)
         @genres = Genre.all
        #ジャンルIDが指定されている場合にそのジャンルに属する商品を取得し
      if params[:genre_id].present?
        @genre = Genre.find_by(id: params[:genre_id])
        if @genre
          @items = @genre.items.where(is_active: true).page(params[:page]).per(8)
          @item_count = @items.total_count
        else
          @items = Item.none.page(params[:page]).per(8)
          @item_count = 0
        end
      else
        @items = Item.where(is_active: true).page(params[:page]).per(8)
        @item_count = @items.total_count
      end
    end
    
    def show
         @item = Item.find(params[:id])
         #商品をカートに追加できるようにする
         @cart_items = current_customer.cart_items if customer_signed_in?
         @genres = Genre.all
    end
    
    #ジャンル検索
    def search
         # ジャンルIDに基づいた商品のクエリを一度だけ実行
    items_query = Item.where(genre_id: params[:genre_id])
    @items = items_query.page(params[:page]).per(8) # 例としてページあたり10項目を表示
    @item_count = items_query.count

    @genres = Genre.where(valid_invalid_status: 0) # 有効なジャンルのみを取得

    render 'index' # 指定したビューファイルを明示的に表示
    end
end
