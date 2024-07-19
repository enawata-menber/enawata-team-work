class Public::OrdersController < ApplicationController
  before_action :authenticate_customer!
  before_action :request_post?, only: [:confirm]
  before_action :order_new?, only: [:new]
    
  def new
    @payment_methods = ['クレジットカード', '銀行振込']
    @addresses = current_customer.addresses # 顧客の登録済み住所を取得
    @order = Order.new
  
  end

  def confirm
    # 注文情報確認画面のロジック
  end

  def thanks
    # 注文完了画面のロジック
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

end