class OrderDetail < ApplicationRecord
  
  #アソシエーション
  belongs_to :order
  belongs_to :item
  
  #item_id,order_id,quantity,priceの欠損確認
  #priceはnumericalityで数値であるか検証、only_integerで整数のみに制限（ここでのpriceは購入価格）
  validates :item_id, :order_id, :amount,
			  		:price, presence: true
	validates :price, :amount, numericality: {only_integer: true}
  
  #makings_statusカラムに入る内容を記述
  enum makings_status: { not_started: 0, pending_production: 1,in_production: 2,completed: 3 }
  
  def with_tax_price
    (price * 1.1).floor
  end

  def with_tax_total_payment
    (total_payment * 1.1).floor
  end
end
