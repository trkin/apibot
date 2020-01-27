class AddJobIdToRuns < ActiveRecord::Migration[6.0]
  def change
    add_column :runs, :job_id, :string
  end
end
