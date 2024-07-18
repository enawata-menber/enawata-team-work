class Public::ItemsController < ApplicationController
    
    def index
        #ジャンルIDが指定されている場合にそのジャンルに属する商品を取得し
      if params[:genre_id].present?
          @genres = Genre.all
          @genre = Genre.find_by(id: params[:genre_id])
          @items = Item.where(genre_id: @genre&.id).page(params[:page]).per(8)
          @item_count = @items.total_count
      else #指定されていない場合は全商品を取得
          @items = Item.all.page(params[:page]).per(8)
           @item_count = @items.total_count
      end
    end
    
    def show
         @item = Item.find(params[:id])
         #商品をカートに追加できるようにする
         @cart_item = CartItem.new
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
