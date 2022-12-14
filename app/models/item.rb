class Item < ApplicationRecord

  has_one_attached :image
  belongs_to :customer

  def get_image
    (image.attached?) ? image : 'no_image.jpg'
  end
end
