class CreateInspects < ActiveRecord::Migration[6.0]
  def change
    create_table :inspects do |t|
      t.references :bot, null: false, foreign_key: true
      t.string :name, null: false
      t.string :target, null: false
      t.string :regexp

      t.timestamps
    end
  end
end
