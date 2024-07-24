module ApplicationHelper
    def price_including_tax(price)
  (price_excluding_tax * 1.10).round  # 税率10%を適用
    end
end
