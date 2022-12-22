class AddDetailsToItems < ActiveRecord::Migration[6.1]
  def change
    add_column :items, :is_admin_published_flag, :boolean, default: true, null: false
  end
end
