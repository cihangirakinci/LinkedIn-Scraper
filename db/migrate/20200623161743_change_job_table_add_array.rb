# frozen_string_literal: true

class ChangeJobTableAddArray < ActiveRecord::Migration[6.0]
  def change
    change_column :jobs, :title, "varchar[] USING (string_to_array(title, ','))"
  end
end
