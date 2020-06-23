# frozen_string_literal: true

class CreateJobs < ActiveRecord::Migration[6.0]
  def change
    create_table :jobs do |t|
      t.string :link
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
