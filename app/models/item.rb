class Item < ApplicationRecord
  
  #アソシエーション
  has_many :cart_items, dependent: :destroy
  has_many :order_details, dependent: :destroy
  belongs_to :genre
  
  #画像保存
  has_one_attached :image
  
end
