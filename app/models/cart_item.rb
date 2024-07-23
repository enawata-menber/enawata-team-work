class CartItem < ApplicationRecord
  
  #アソシエーション
  belongs_to :customer
  belongs_to :item
  
  
  #customer_idとitem_idとamountの欠損確認
  #amountはnumericalityで数値であるか検証、only_integerで整数のみに制限
#   validates :customer_id, :item_id, :amount, presence: true
# 	validates :amount, numericality: {only_integer: true}
     validates :amount, presence: true, numericality: { only_integer: true, greater_than: 0 }

end
