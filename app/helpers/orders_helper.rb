module OrdersHelper
  def self.category(order)
    category = []
    order.services.each do |l|
      category << l.category.title
    end
    category.uniq.join("\n")
  end
end
