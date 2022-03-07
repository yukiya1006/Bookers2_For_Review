class CreateBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :books do |t|
      t.string :title
      t.text :body
      t.float :star
      t.integer :user_id
      t.integer :category_id
      t.string :category
      t.timestamps
    end
  end
end