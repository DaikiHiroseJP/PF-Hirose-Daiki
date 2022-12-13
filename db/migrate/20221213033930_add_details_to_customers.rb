class AddDetailsToCustomers < ActiveRecord::Migration[6.1]
  def change
    add_column :customers, :name, :string
    add_column :customers, :introduction, :text
  end
end
