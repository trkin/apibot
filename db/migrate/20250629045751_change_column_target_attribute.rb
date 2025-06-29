class ChangeColumnTargetAttribute < ActiveRecord::Migration[6.1]
  def change
    change_column_default :inspects, :target_attribute, ""
  end
end
