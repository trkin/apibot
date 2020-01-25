class CreateRuns < ActiveRecord::Migration[6.0]
  def change
    create_table :runs do |t|
      t.references :bot, null: false, foreign_key: true
      t.string :status, null: false
      t.text :log
      t.datetime :finished_at

      t.timestamps
    end
  end
end
