class Category < ApplicationRecord
  has_many :services, dependent: :destroy

  has_many :orders, through: :services
  validates :title, presence: true, length: {minimum: 5}

  def formatted_created_at
    created_at.strftime('%Y-%m-%d %H:%M:%S')
  end
end
