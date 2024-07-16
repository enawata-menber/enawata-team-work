class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
 
  #アソシエーション
  has_many :cart_items, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :addresses, dependent: :destroy
  
  #バリデーション
  validates :first_name,
          :last_name,
          :postal_code,
          :telephone_number,
          presence: true
          
  #住所は文字数が7、数字のみの入力に制限
  validates :postal_code, length: {is: 7}, numericality: { only_integer: true }
  #電話番号は、数字のみの入力に制限
  validates :telephone_number, numericality: { only_integer: true }
  #カタカナのみの入力に制限
  validates :kana_first_name, :kana_last_name,
  format: { with: /\A[\p{katakana}\p{blank}ー－]+\z/, message: "カタカナで入力して下さい。"}
  
  #退会機能
  def active_for_authentication?
    super && (self.is_active == false)
  end
end
