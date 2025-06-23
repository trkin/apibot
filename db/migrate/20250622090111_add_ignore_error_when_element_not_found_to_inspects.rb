class AddIgnoreErrorWhenElementNotFoundToInspects < ActiveRecord::Migration[6.1]
  def change
    add_column :inspects, :ignore_error_when_element_not_found, :boolean, default: false
  end
end
