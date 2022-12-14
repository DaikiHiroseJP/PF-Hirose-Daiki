class RenameUserIdColumnToItems < ActiveRecord::Migration[6.1]
  def change
    rename_column :items, :user_id, :customer_id
  end
end
