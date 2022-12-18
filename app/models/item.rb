class Item < ApplicationRecord

  has_one_attached :image
  belongs_to :customer
  has_many :favorite, dependent: :destroy
  has_many :favorited_customers, through: :favorite, source: :customer
  has_many :item_comments, dependent: :destroy

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


  def self.looks(search, word)
    if search == "perfect_match"
      @item = Item.where("title LIKE?","#{word}")
    elsif search == "forward_match"
      @item = Item.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @item = Item.where("title LIKE?","%#{word}")
    elsif search == "partial_match"
      @item = Item.where("title LIKE?","%#{word}%")
    else
      @item = Item.all
    end
  end

  def self.search(search_word)
    Item.where(['category LIKE ?', "#{search_word}"])
  end

  def get_image
    (image.attached?) ? image : 'no_image.jpg'
  end
end
