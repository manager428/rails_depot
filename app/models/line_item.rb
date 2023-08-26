class LineItem < ApplicationRecord
  belong_to :order, optional: true
  belongs_to :product
  belongs_to :cart, optional: true

  def total_price
    product.price * quantity
  end
end
