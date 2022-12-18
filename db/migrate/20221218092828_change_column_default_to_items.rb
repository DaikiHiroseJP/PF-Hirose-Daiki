class ChangeColumnDefaultToItems < ActiveRecord::Migration[6.1]
  def change
    change_column_default :items, :is_published_flag, from: nil, to: false
  end
end
