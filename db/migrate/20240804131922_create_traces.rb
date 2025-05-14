class CreateTraces < ActiveRecord::Migration[6.1]
  def change
    create_table :traces do |t|
      t.references :bot, null: false, foreign_key: true
      t.string :name
      t.jsonb "config", default: {}

      t.timestamps
    end
  end
end
