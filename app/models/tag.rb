class Tag < ApplicationRecord

  has_many :item_tags,dependent: :destroy, foreign_key: 'tag_id'
  # タグは複数の投稿を持つ　それは、item_tagsを通じて参照できる
  has_many :items,through: :item_tags

  validates :name, uniqueness: true, presence: true,length:{maximum:28}
end
