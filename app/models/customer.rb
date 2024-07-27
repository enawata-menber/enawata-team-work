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
  validates :first_name_kana, :last_name_kana,
  format: { with: /\A[\p{katakana}\p{blank}ー－]+\z/}
    
  def full_name #フルネーム表示のため追加（おはる）
    first_name + '' + last_name
  end
  
  def full_name_kana #かなフルネーム表示のため追加（おはる）kanaの位置を修正(ひで)
    first_name_kana + '' + last_name_kana
  end
  
  def customer_status #会員ステータス追加（おはる）is_activeでfalseに修正(ひで)
    if is_active == false
      "退会"
    else
      "有効"
    end
  end
  
end
