# frozen_string_literal: true

class ChangeDateToString < ActiveRecord::Migration[6.0]
  def change
    change_column :jobs, :date, :string
  end
end
