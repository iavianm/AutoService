module OrdersHelper
  def self.service(order)
    service = []
    order.services.each do |l|
      service << l.title
    end
    service.uniq.join(', ')
  end

  def self.category(order)
    category = []
    order.categories.each do |l|
      category << l.title
    end
    category.uniq.join(', ')
  end
end
