class AddValueTargetToInspects < ActiveRecord::Migration[6.0]
  def change
    add_column :inspects, :value_target, :string, default: 'text', null: false
  end
end
