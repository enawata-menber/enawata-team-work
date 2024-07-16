class OrderDetail < ApplicationRecord
  
  #アソシエーション
  belongs_to :order
  belongs_to :item
  
  #item_id,order_id,quantity,priceの欠損確認
  #priceはnumericalityで数値であるか検証、only_integerで整数のみに制限（ここでのpriceは購入価格）
  validates :item_id, :order_id, :quantity,
			  		:price, presence: true
	validates :price, :quantity, numericality: {only_integer: true}
  
  #order_statusカラムに入る内容を記述
  enum order_status: {"着手不可" => 0,"製作待ち" => 1,"制作中" => 2,"製作完了" => 3,}

end
