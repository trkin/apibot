class AddInterpolationToInspects < ActiveRecord::Migration[6.1]
  def change
    add_column :inspects, :interpolation, :string, null: false, default: ""
  end
end
