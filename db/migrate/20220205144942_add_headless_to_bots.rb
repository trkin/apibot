class AddHeadlessToBots < ActiveRecord::Migration[6.0]
  def change
    add_column :bots, :headless, :boolean, default: false, null: false
    remove_column :bots, :engine
  end
end
