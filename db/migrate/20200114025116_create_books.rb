class CreateBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.text :description
      t.string :price
      t.integer :no_of_likes
      t.datetime :published_at

      t.timestamps
    end
  end
end
