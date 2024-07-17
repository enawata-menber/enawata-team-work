class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  
  #priceに対して、10%をかけている
  def tax_in_price
    (price * 1.1).floor
  end
end

