class AddDeletedToJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :jobs, :deleted, :boolean, default: false
  end
end
