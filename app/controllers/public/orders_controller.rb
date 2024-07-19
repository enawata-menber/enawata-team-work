class Public::OrdersController < ApplicationController
  before_action :set_devise_mapping #Deviseに対して現在のリクエストがどのモデル（ここではcustomer）にマッピングされているかを手動で設定
  before_action :authenticate_customer!
  before_action :request_post?, only: [:confirm]
  before_action :order_new?, only: [:new]
    
  def new
    @payment_methods = ['クレジットカード', '銀行振込']
    @addresses = current_customer.addresses # 顧客の登録済み住所を取得
    @order = Order.new
  
  end

  def confirm
    @order = Order.new(order_params)
    @cart_items = current_customer.cart_items
    @shipping_cost = calculate_shipping_cost(@order.address_id)
    #カート内の商品の合計金額と送料を計算して、請求金額（総額）を算出
    @total_price = @cart_items.sum { |item| item.product.price * item.quantity } + @shipping_cost
    
     case params[:order][:address_option]
      when 'self'#ユーザーが「自分の住所」を選択した場合の処理
        @order.name = current_customer.name
        @order.address = current_customer.full_address
        @order.postal_code = current_customer.postal_code
      when 'select' #ユーザーが「登録先住所（自分以外）」を選択した場合の処理
        selected_address = current_customer.addresses.find(params[:order][:selected_address_id])
        @order.name = selected_address.name
        @order.address = selected_address.full_address
        @order.postal_code = selected_address.postal_code
      when 'new' #ユーザーが「新しい住所」を入力した場合の処理
        @order.name = params[:order][:new_name]
        @order.address = params[:order][:new_address]
        @order.postal_code = params[:order][:new_postal_code]
  　　end
　　end

  def thanks
    # 注文完了画面のロジック
  end

  def create
      @order = Order.new(order_params)
      @order.customer_id = current_customer.id
    if @order.save
      current_customer.cart_items.each do |cart_item|
        @order.order_items.create(
          product_id: cart_item.product_id,
          quantity: cart_item.quantity,
          price: cart_item.product.price
        )
      end
      current_customer.cart_items.destroy_all
      redirect_to thanks_public_orders_path
    else
      render :confirm
    end
  end

  private
  
   def set_devise_mapping #eviseが正しいマッピングを使用するように設定
    @request.env["devise.mapping"] = Devise.mappings[:customer]
 　 end
  
  def authenticate_customer!
    # ユーザーがログインしていない場合の処理をここに記述
    redirect_to login_path unless customer_logged_in?
  end

  def request_post?
      #confirm アクションがPOSTリクエストであることを確認し、そうでない場合は新規注文ページにリダイレクト
    unless request.post?
      redirect_to new_order_path, alert: 'もう一度最初から入力してください。'
    end
  end

  def order_new?
        redirect_to public_cart_items_path, notice: "カートに商品を入れてください。" 
     if current_member.cart_items.blank?
         unless can_create_order?
            redirect_to root_path, alert: '注文を作成できません。在庫が不足しています。'
         end 
     end
  end

  def customer_logged_in?
    # ログインしているかどうかを確認
    !!session[:customer_id]
  end

  def can_create_order?
    current_customer.cart_items.all? do |item|
      item.product.stock >= item.quantity
    end
  end
  #指定されたパラメータのみがマスアサインメントで利用され、不正なパラメータの混入を防ぐ。
  def order_params
    params.require(:order).permit(:payment_method, :address_id)
  end
  #指定された住所IDに基づいて送料を計算
  def calculate_shipping_cost(address_id)
    address = current_customer.addresses.find(address_id)
    address.shipping_cost
  end

end