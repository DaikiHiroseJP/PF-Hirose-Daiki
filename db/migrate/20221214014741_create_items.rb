class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.string :title
      t.text :body
      t.integer :user_id
      t.string :category
      t.float :star
      t.timestamps
    end
  end
end
