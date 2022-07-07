class LineItem < ApplicationRecord
  belongs_to :service
  belongs_to :cart

  def total_price
    service.cost * quantity
  end
end
