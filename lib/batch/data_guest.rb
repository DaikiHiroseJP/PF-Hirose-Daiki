class Batch::DataGuest

  # guestuserの投稿を削除
  def self.data_reset
    user = Customer.find_by(email: "guest@example.com")
    user.items.destroy_all
    user.item_comments.destroy_all
    user.favorite.destroy_all
  end
end