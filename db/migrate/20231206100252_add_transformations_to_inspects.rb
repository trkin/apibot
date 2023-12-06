class AddTransformationsToInspects < ActiveRecord::Migration[6.1]
  def change
    add_column :inspects, :transformations, :string, array: true, default: []
  end
end
