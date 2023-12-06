class AddConfigToBots < ActiveRecord::Migration[6.0]
  def change
    add_column :bots, :config, :jsonb, default: {}
  end
end
