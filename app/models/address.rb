class Address < ApplicationRecord
  
#アソシエーション
belongs_to :customer

validates :postal_code, length: {is: 7}, numericality: {only_integer: true}
validates :address, presence: true
validates :name, presence: true
  
  
  
def order_address
	self.postal_code + self.address + self.name
end
	
end
