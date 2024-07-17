class Genre < ApplicationRecord
  
  #アソシエーション
  has_many :items, dependent: :destroy
  #nameの欠損確認
  validates :name, presence: true
end
