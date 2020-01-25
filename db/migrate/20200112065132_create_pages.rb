class CreatePages < ActiveRecord::Migration[6.0]
  def change
    create_table :pages do |t|
      t.references :run, null: false, foreign_key: true
      t.string :url, nill: false
      t.text :content, null: false
      t.text :data

      t.timestamps
    end
  end
end
