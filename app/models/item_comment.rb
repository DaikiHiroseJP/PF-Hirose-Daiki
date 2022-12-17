class ItemComment < ApplicationRecord
  belongs_to :customer
  belongs_to :item

  validates :comment, presence: true
end
