class Order < ApplicationRecord
  has_many :line_items, dependent: :destroy
  has_many :services, through: :line_items
  has_many :categories, through: :services
  validates :name, :email, presence: true
  
  enum pay_type: {
    "Check" => "Check",
    "Credit card" => "Credit card",
    "Purchase order" => "Purchase order"
  }
  
  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end
end
