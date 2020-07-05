class AddCompanyNameToJobTable < ActiveRecord::Migration[6.0]
  def change
    add_column :jobs, :company, :string
  end
end
