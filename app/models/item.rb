class Item < ApplicationRecord
  
  #アソシエーション
  has_many :cart_items, dependent: :destroy
  has_many :order_details, dependent: :destroy
  belongs_to :genre
  
  #画像保存
  has_one_attached :image
  
  def get_proauct_image(width, height)
  # 画像の取得処理を実装する
  end
  
  #genre_id,name,price,の欠損確認
  #priceはnumericalityで数値であるか検証、only_integerで整数のみに制限（ここでのpriceは税抜き価格）
  validates :genre_id, :name, :price, presence: true
	validates :introduction, length: {maximum: 200}
	validates :price, numericality: {only_integer: true}
	
end
