class RenameValueTargetToTargetAttributeFromInspects < ActiveRecord::Migration[6.1]
  def change
    rename_column :inspects, :value_target, :target_attribute
  end
end
