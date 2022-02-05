class CreateCompanies < ActiveRecord::Migration[6.0]
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.boolean :enable_sign_up, null: false, default: false

      t.timestamps
    end
  end
end
