class ItemComment < ApplicationRecord
  belongs_to :customer
  belongs_to :item

  validates :comment, presence: true ,length:{maximum:50}
end
