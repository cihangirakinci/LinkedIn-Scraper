# frozen_string_literal: true

class ChangeJobTableAddString < ActiveRecord::Migration[6.0]
  def change
    change_column :jobs, :title, :string
  end
end
