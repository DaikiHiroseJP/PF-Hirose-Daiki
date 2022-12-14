class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_image
  has_many :items, dependent: :destroy

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

end
