class Public::OrdersController < ApplicationController
  before_action :set_devise_mapping, except: [:thanks] # Deviseに対して現在のリクエストがどのモデル（ここではcustomer）にマッピングされているかを手動で設定
  before_action :authenticate_customer!
  before_action :request_post?, only: [:confirm]
  before_action :order_new?, only: [:new]

  def index
    @orders = current_customer.orders
  end
  
  def show
    @order = Order.find(params[:id])
    @order_details = @order.order_details
    @genres = Genre.all # ジャンルの取得を追加
  end
  
  def new
    @peyment_methods = ['クレジットカード', '銀行振込']
    @addresses = current_customer.addresses # 顧客の登録済み住所を取得
    @order = Order.new
  end

def confirm
  @order = Order.new(order_params)
  @cart_items = current_customer.cart_items
  @shipping_cost = calculate_shipping_cost(@order.address)
  @total_price = @cart_items.sum { |cart_item| cart_item.item.price * cart_item.amount } + @shipping_cost

  case params[:order][:address_option]
  when 'self'
    @order.name = current_customer.full_name
    @order.address = current_customer.address
    @order.postal_code = current_customer.postal_code
  when 'select'
    selected_address = current_customer.addresses.find(params[:order][:selected_address_id])
    @order.name = selected_address.name
    @order.address = selected_address.full_address
    @order.postal_code = selected_address.postal_code
  when 'new'
    @order.name = params[:order][:new_name]
    @order.address = params[:order][:new_address]
    @order.postal_code = params[:order][:new_postal_code]
  end
end

  def create
    @order = Order.new(order_params)
    @order.customer_id = current_customer.id
    @order.shipping_cost = 800
    @cart_items = current_customer.cart_items
    @total_price = @cart_items.sum { |cart_item| cart_item.item.price * cart_item.amount }
    @order.total_payment = @total_price +  @order.shipping_cost
    p @order
    if @order.save
      current_customer.cart_items.each do |cart_item|
        @order.order_details.create(
          item_id: cart_item.item_id,
          amount: cart_item.amount,
          price: cart_item.item.price
        )
      end
      current_customer.cart_items.destroy_all
      redirect_to thanks_public_orders_path, notice: '注文が完了しました。'
    else
      render :confirm
    end
    # 例外処理用の記述
    # rescue => e
    # logger.error "Order creation failed: #{e.message}"
    # redirect_to public_cart_items_path, alert: '注文の作成に失敗しました。再度お試しください。'
    # end
    
    def thanks
    # 注文完了画面のロジック
    end

  private

  def set_devise_mapping # Deviseが正しいマッピングを使用するように設定
    request.env["devise.mapping"] = Devise.mappings[:customer]
  end

  def authenticate_customer!
    # ユーザーがログインしていない場合の処理をここに記述
    redirect_to new_customer_session_path unless customer_logged_in?
  end

  def request_post?
    # confirm アクションがPOSTリクエストであることを確認し、そうでない場合は新規注文ページにリダイレクト
    unless request.post?
      redirect_to new_order_path, alert: 'もう一度最初から入力してください。'
    end
  end

  def order_new?
    if current_customer.cart_items.blank?
      redirect_to public_cart_items_path, notice: "カートに商品を入れてください。"
    else
      unless can_create_order?
        redirect_to public_cart_items_path, alert: '注文を作成できません。在庫が不足しています。'
      end
    end
  end

  def customer_logged_in?
    # ログインしているかどうかを確認
    !!current_customer
  end

  def can_create_order?
    current_customer.cart_items.all? do |cart_item|
      #在庫の代わりにis_active属性を使用して商品の販売ステータスを確認
      cart_item.item.is_active
    end
  end

  # 指定されたパラメータのみがマスアサインメントで利用され、不正なパラメータの混入を防ぐ。
  def order_params
   params.require(:order).permit(:delivery_address, :delivery_date, :peyment_method, :name, :address, :postal_code)
  end

  # 指定された住所IDに基づいて送料を計算
  def calculate_shipping_cost(address)
    # ここで address を使用して送料を計算するロジックを追加
    # 一律800円とする場合
    800
  end
end