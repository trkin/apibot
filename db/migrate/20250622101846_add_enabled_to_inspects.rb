class AddEnabledToInspects < ActiveRecord::Migration[6.1]
  def change
    add_column :inspects, :enabled, :boolean, default: true
  end
end
