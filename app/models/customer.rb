class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
 
  #アソシエーション
  has_many :cart_items, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :addresses, dependent: :destroy
  
  #first_name,last_name,postal_code,telephone_number,の欠損確認
  #郵便番号を7桁に指定、numericalityで数値であるか検証、only_integerで整数のみに制限
  #電話番号はnumericalityで数値であるか検証、only_integerで整数のみに制限
  #カタカナのみの入力に制限
  validates :first_name, :last_name,
            :postal_code, :telephone_number,
            presence: true
  validates :postal_code, length: {is: 7}, numericality: {only_integer: true}
  validates :telephone_number, numericality: {only_integer: true}
  validates :kana_first_name, :kana_last_name,
  format: { with: /\A[\p{katakana}\p{blank}ー－]+\z/, message: "カタカナで入力して下さい。"}
    
  def full_name #フルネーム表示のため追加（おはる）
    first_name + '' + last_name
  end
  
  def full_name_kana #かなフルネーム表示のため追加（おはる）
    kana_first_name + '' + kana_last_name
  end
  
  def customer_status #会員ステータス追加（おはる）
    if is_deleted == true
      "退会"
    else
      "有効"
    end
  end
  
  #退会済みかどうか確認する
  def active_for_authentication?
    super && (self.is_active == false)
  end
end
