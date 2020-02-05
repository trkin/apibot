class AddErrorLogToRuns < ActiveRecord::Migration[6.0]
  def change
    add_column :runs, :error_log, :text
    add_column :pages, :error_log, :text
  end
end
