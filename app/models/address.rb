class Address < ApplicationRecord
  
  #アソシエーション
  belongs_to :customer
  
  #order_addressメソッドを使用して、登録した郵便番号、住所、宛名を表示させる
  #もしよかったら使ってください
  def order_address
			self.postal_code + self.address + self.name
	end
end
