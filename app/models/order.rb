class Order < ApplicationRecord
  
  #アソシエーション
  belongs_to :customer
  has_many :order_details, dependent: :destroy
  # has_many :items, through: :order_details
  
  #customer_id,address,name,shipping_cost,total_price,payment_method,の欠損確認
  #postal_codeは7文字に指定、numericalityで数値であるか検証、only_integerで整数のみに制限
	#shipping_cost,total_priceはnumericalityで数値であるか検証、only_integerで整数のみに制限
  validates :customer_id, :address,:name, :shipping_cost,
			  		:total_payment, :peyment_method,
			  		presence: true
	validates :postal_code, length: {is: 7}, numericality: {only_integer: true}
	validates :shipping_cost, :total_payment, numericality: {only_integer: true}
  
  #payment_methodカラムとstatusカラムに入る内容を記入
  enum peyment_method: {"クレジットカード" => 0,"銀行振込" => 1,}
  enum status: {"入金待ち" => 0,"入金確認" => 1,"製作中" => 2, "発送準備中" => 3, "発送済み" => 4,}
end
