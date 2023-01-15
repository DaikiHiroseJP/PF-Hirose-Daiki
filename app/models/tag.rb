class Tag < ApplicationRecord
before_save :downcase_tag_name

  has_many :item_tags, dependent: :destroy
  has_many :items,through: :item_tags

  validates :name, uniqueness: true, presence: true, length: { maximum: 10 }

  private

  # タグ名を小文字に変換
  def downcase_tag_name
    self.name.downcase!
  end
end


