class Public::CartItemsController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_cart_item, only: [:update, :destroy]
  before_action :ensure_cart_item_amount_present, only: [:create]

  # カート内商品一覧画面(数量変更・カート削除の要素を含む)
  def index
    @cart_items = current_customer.cart_items
    #@total_price = @cart_items.sum { |cart_item| cart_item.item.price * cart_item.amount }
    @total_price = @cart_items.sum { |item| item.subtotal }

    Rails.logger.debug "Current customer: #{current_customer.inspect}"
    Rails.logger.debug "Cart items: #{@cart_items.inspect}"
  end

  # カート内商品データ追加
  def create
    @cart_item = current_customer.cart_items.find_or_initialize_by(item_id: params[:item_id])
    @cart_item.amount = (@cart_item.amount || 0) + params[:amount].to_i

    Rails.logger.debug "Attempting to create cart item: #{@cart_item.inspect}"

    if @cart_item.save
      Rails.logger.debug "CartItem created: #{@cart_item.inspect}"
      redirect_to public_cart_items_path, notice: '商品がカートに追加されました。'
    else
      Rails.logger.debug "CartItem creation failed: #{@cart_item.errors.full_messages.join(', ')}"
      redirect_to public_item_path(params[:item_id]), alert: '商品をカートに追加できませんでした。'
    end
  end

  # カート内商品データ更新
  def update
    if @cart_item.update(cart_item_params)
      redirect_to public_cart_items_path, notice: 'カートが更新されました。'
    else
      redirect_to public_cart_items_path, alert: 'カートを更新できませんでした。'
    end
  end

  # カート内商品データ削除(一商品)
  def destroy
    @cart_item.destroy
    redirect_to public_cart_items_path, notice: 'カートアイテムが削除されました。'
  end

  # カート内商品データ削除(全て)
  def destroy_all
    current_customer.cart_items.destroy_all
    redirect_to public_cart_items_path, notice: 'カート内の全てのアイテムが削除されました。'
  end

  private

  def set_cart_item
    @cart_item = current_customer.cart_items.find(params[:id])
  end

  def ensure_cart_item_amount_present
    if params[:amount].blank?
      redirect_to public_item_path(params[:item_id]), notice: "個数を入力してください。"
    end
  end

  def cart_item_params
    params.require(:cart_item).permit(:item_id, :amount)
  end
end