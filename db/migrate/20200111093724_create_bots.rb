class CreateBots < ActiveRecord::Migration[6.0]
  def change
    create_table :bots do |t|
      t.string :start_url, null: false
      t.string :name
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
