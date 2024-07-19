class Public::CartItemsController < ApplicationController
    # before_action :authenticate_customer!
     before_action :authenticate_customer!, except: [:index]

    before_action :set_cart_item, only: [:update, :destroy]
    before_action :ensure_cart_item_quantity_present, only: [:create]
    
     # カート内商品一覧画面(数量変更・カート削除の要素を含む)
    def index
        # @cart_items = current_customer.cart_items
        # @total = 0
        # Rails.logger.debug "Current customer: #{current_customer.inspect}"
        # if current_customer
        #   @cart_items = current_customer.cart_items
        #   @total = 0
        # else
        #   redirect_to new_customer_session_path, alert: 'カートの商品を見るにはログインしてください。'
        # end
        
        # ログインしていない時にindex表示を確認するための記述（ログインできるようになったら上記の記述に変更）
         Rails.logger.debug "Current customer: #{current_customer.inspect}"

        if current_customer
          @cart_items = current_customer.cart_items
        else
          @cart_items = []  # current_customerがnilの場合、空の配列を設定
        end
        @total = 0
    end

        
    # カート内商品データ更新
    def update
        if @cart_item.update(cart_item_params)
          redirect_to public_cart_items_path, notice: 'カートアイテムが更新されました。'
        else
          render 'index', alert: 'カートアイテムの更新に失敗しました。'
        end
    end
    
    # カート内商品データ削除(一商品)
    def destroy
        @cart_item.destroy
        redirect_to public_cart_items_path, notice: 'カートアイテムが削除されました。'
    end
    # カート内商品データ削除(全て)
    def destroy_all
        current_user.cart_items.destroy_all
        redirect_to public_cart_items_path, notice: 'カート内の全てのアイテムが削除されました。'
    end
    # カート内商品データ追加
    def create
        existing_cart_item = current_user.cart_items.find_by(item_id: params[:cart_item][:item_id])
        if existing_cart_item  #既存のカートアイテムを更新
          update_existing_cart_item(existing_cart_item)
        else     #新しいカートアイテムを作成
          create_new_cart_item
        end
    end
    
    private

      def set_cart_item
        @cart_item = CartItem.find(params[:id])
      end
    
      def ensure_cart_item_quantity_present
        if params[:cart_item][:number_of_items].blank?
          redirect_to public_item_path(params[:cart_item][:item_id]), notice: "個数を入力してください。"
        end
      end
    
      def cart_item_params
        params.require(:cart_item).permit(:item_id, :number_of_items, :customer_id)
      end
    
      def update_existing_cart_item(cart_item)
        cart_item.number_of_items += params[:cart_item][:number_of_items].to_i
        if cart_item.save
          redirect_to public_cart_items_path, notice: 'カートアイテムが更新されました。'
        else
          render 'index', alert: 'カートアイテムの更新に失敗しました。'
        end
      end
    
      def create_new_cart_item
        @cart_item = CartItem.new(cart_item_params)
        @cart_item.member_id = current_user.id
        if @cart_item.save
          redirect_to public_cart_items_path, notice: 'カートアイテムが追加されました。'
        else
          load_additional_resources
          render 'index', alert: 'カートアイテムの追加に失敗しました。'
        end
      end
    
      def load_additional_resources
        @items = Item.where(sale_status: 0).page(params[:page]).per(8)
        @quantity = Item.count
        @genres = Genre.where(valid_invalid_status: 0)
      end
end
