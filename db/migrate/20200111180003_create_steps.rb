class CreateSteps < ActiveRecord::Migration[6.0]
  def change
    create_table :steps do |t|
      t.references :bot, null: false, foreign_key: true
      t.integer :position
      t.string :action, null: false
      t.string :what
      t.string :with

      t.timestamps
    end
  end
end
