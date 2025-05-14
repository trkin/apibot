class CreateInspectTraces < ActiveRecord::Migration[6.1]
  def change
    create_table :inspect_traces do |t|
      t.references :inspect, null: false, foreign_key: true
      t.references :trace, null: false, foreign_key: true
      t.string :value

      t.timestamps
    end

    add_index :inspect_traces, [:inspect_id, :trace_id], unique: true
  end
end
