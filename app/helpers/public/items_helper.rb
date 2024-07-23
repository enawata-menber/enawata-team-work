module Public::ItemsHelper
   #消費税計算(税込価格にする)
    def price_including_tax(price_excluding_tax)
    tax_rate = 0.10  # 10%の税率として設定
       (price_excluding_tax * (1 + tax_rate)).round(2)
    end
end
