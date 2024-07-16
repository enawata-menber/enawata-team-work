class OrderDetail < ApplicationRecord
  
  #アソシエーション
  belongs_to :order
  belongs_to :item
  #order_statusカラムに入る内容を記述
  enum order_status: {"着手不可" => 0,"製作待ち" => 1,"制作中" => 2,"製作完了" => 3,}

end
