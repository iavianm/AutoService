class Service < ApplicationRecord
  belongs_to :category

  validates :title, presence: true, length: {minimum: 5}
  validates :cost, presence: true
end
