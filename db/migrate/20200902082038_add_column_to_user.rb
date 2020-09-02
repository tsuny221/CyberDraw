class AddColumnToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name, :string
    add_column :users, :birth_date, :date
    add_column :users, :introduction, :string
    add_column :users, :gender, :integer
  end
end
