class AddPositionToInspects < ActiveRecord::Migration[6.1]
  def change
    add_column :inspects, :position, :integer
  end
end
