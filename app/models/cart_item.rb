class CartItem < ApplicationRecord
  
  #アソシエーション
  belongs_to :customer
  belongs_to :item
  
  # 消費税を求めるメソッド
  def with_tax_price
    (price * 1.1).floor
  end
  
  ## 小計を求めるメソッド
def subtotal
    item.with_tax_price * amount
end
  
  #customer_idとitem_idとamountの欠損確認
  #amountはnumericalityで数値であるか検証、only_integerで整数のみに制限
#   validates :customer_id, :item_id, :amount, presence: true
# 	validates :amount, numericality: {only_integer: true}
     validates :amount, presence: true, numericality: { only_integer: true, greater_than: 0 }

end
