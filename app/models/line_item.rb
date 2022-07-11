class LineItem < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :service
  belongs_to :cart, optional: true
  

  def total_price
    service.cost * quantity
  end
end
