class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :caption
      t.integer :age_limit
      t.integer :open_range
      t.references :user
      t.timestamps
    end
  end
end
