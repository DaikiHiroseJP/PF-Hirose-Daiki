class Tag < ApplicationRecord
    before_save :downcase_tag_name

  has_many :item_tags,dependent: :destroy, foreign_key: 'tag_id'
  # タグは複数の投稿を持つ　それは、item_tagsを通じて参照できる
  has_many :items,through: :item_tags

  validates :name, length: { maximum: 10 }

  private

  # タグ名を小文字に変換
  def downcase_tag_name
    self.name.downcase!
  end
end
