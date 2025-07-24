class AddShownInOutputToInspects < ActiveRecord::Migration[6.1]
  def change
    rename_column :inspects, :enabled, :shown_in_output
  end
end
