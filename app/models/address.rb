class Address < ApplicationRecord
  
#アソシエーション
belongs_to :customer

validates :postal_code, length: {is: 7}, numericality: {only_integer: true}
validates :address, presence: true
validates :name, presence: true
  
  
  #order_addressメソッドを使用して、登録した郵便番号、住所、宛名を表示させる
  #もしよかったら使ってください

  def order_address
			self.postal_code + self.address + self.name
  end
  
  #注文情報で住所と宛名を結合した文字列を返すようにする
  def full_address_with_name
    "#{address} (#{name})"
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
