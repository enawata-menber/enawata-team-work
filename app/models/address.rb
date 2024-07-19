class Address < ApplicationRecord
  
  #アソシエーション
  belongs_to :customer
  
  #order_addressメソッドを使用して、登録した郵便番号、住所、宛名を表示させる
  #もしよかったら使ってください
  def order_address
			self.postal_code + self.address + self.name
  end
  #送料を住所で変更する
   # 都道府県のリスト
  PREFECTURES = {
    '東京都' => 500,
    '大阪府' => 800,
    '北海道' => 1000,
    # その他の都道府県を追加
  }

  def shipping_cost
    PREFECTURES[prefecture] || 600 # デフォルトの送料を設定
  end
end
