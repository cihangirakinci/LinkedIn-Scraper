# frozen_string_literal: true

class AddTimeToJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :jobs, :date, :date
  end
end
