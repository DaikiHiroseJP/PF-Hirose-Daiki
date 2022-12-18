class AddCulmsToItems < ActiveRecord::Migration[6.1]
  def change
    add_colnum :items, :is_published_flag, :boolean
  end
end
