class Service < ApplicationRecord
  belongs_to :category
  has_many :line_items

  before_destroy :ensure_not_referenced_by_any_line_item

  validates :title, presence: true, length: {minimum: 5}
  validates :cost, presence: true

  private

  def ensure_not_referenced_by_any_line_item
    if line_items.empty?
      return true
    else
      errors.add(:base, 'существуют заказаные позиции')
      return false
    end
  end
end
