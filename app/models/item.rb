class Item < ApplicationRecord

  has_one_attached :image
  belongs_to :customer
  has_many :favorite, dependent: :destroy
  has_many :favorited_customers, through: :favorite, source: :customer
  has_many :item_comments, dependent: :destroy
  has_many :item_tags, dependent: :destroy
  has_many :tags, through: :item_tags

  scope :created_today, -> { where(created_at: Time.zone.now.all_day) } # 今日
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) } # 前日
  scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) }
  scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day) }
  scope :created_2days, -> { where(created_at: 2.days.ago.all_day) }
  scope :created_3days, -> { where(created_at: 3.days.ago.all_day) }
  scope :created_4days, -> { where(created_at: 4.days.ago.all_day) }
  scope :created_5days, -> { where(created_at: 5.days.ago.all_day) }
  scope :created_6days, -> { where(created_at: 6.days.ago.all_day) }
  scope :latest, -> {order(created_at: :desc)}
  scope :old, -> {order(created_at: :asc)}
  scope :star_count, -> {order(star: :desc)}

  scope :published, -> {where(is_published_flag: true)}
  scope :unpublished, -> {where(is_published_flag: false)}
  scope :admin_published, -> {where(is_admin_published_flag: true)}
  scope :admin_unpublished, -> {where(is_admin_published_flag: false)}

  validates_associated :tags

  validates :title,presence:true,length:{maximum:50}
  validates :body,presence:true,length:{maximum:200}
  validates :star,presence:true


  def self.looks(search, word)
     if search == "latest_field"
       @items = Item.where("title LIKE?","%#{word}%").published.admin_published.order(created_at: :desc)
     elsif search == "old_field"
       @items = Item.where("title LIKE?","%#{word}%").published.admin_published.order(created_at: :asc)
     elsif search == "star_count_field"
       @items = Item.where("title LIKE?","%#{word}%").published.admin_published.order(star: :desc)
     elsif search == "favorite_week"
      to  = Time.current.at_end_of_day
      from  = (to - 6.day).at_beginning_of_day
      @items = Item.includes(:favorited_customers).published.admin_published
        .sort {|a,b|
        b.favorite.where(created_at: from...to).size <=>
        a.favorite.where(created_at: from...to).size
      }
     else
       該当する投稿はありません。
     end

  end
  #必要なくなったのでコメントアウト、必要に応じて削除。
  # def self.search(search_word)
  #   Item.where(['category LIKE ?', "#{search_word}"]).published
  # end

  def get_image
    (image.attached?) ? image : 'no_image.jpg'
  end

  def save_tags(tag_list)
    tag_list.each do |tag|
      # 受け取った値を小文字に変換して、DBを検索して存在しない場合は
      # find_tag に nil が代入され　nil となるのでタグの作成が始まる
      unless find_tag = Tag.find_by(name: tag.downcase)
        begin
          # create メソッドでタグの作成
          # create! としているのは、保存が成功しても失敗してもオブジェクトを返してしまうため、例外を発生させたい
          self.tags.create!(name: tag)

        # 例外が発生すると rescue 内の処理が走り nil となるので
        # 値は保存されないで次の処理に進む
        rescue
          nil
        end
      else
            # DB にタグが存在した場合、中間テーブルにブログ記事とタグを紐付けている
        ItemTag.create!(item_id: self.id, tag_id: find_tag.id)
      end
    end
  end

  def update_tags(tag_list)
    item_tags.map(&:destroy)
    return unless tag_list
    tag_list.each do |tag|
      tag = Tag.find_or_create_by(name: tag)
      ItemTag.create!(tag: tag, item: self)
    end
  end
end
