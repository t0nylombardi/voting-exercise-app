# frozen_string_literal: true

class CreateCandidates < ActiveRecord::Migration[7.0]
  def change
    create_table :candidates, id: false do |t|
      t.string :id, primary_key: true
      t.string :name, null: false
      t.integer :vote_count, default: 0

      t.timestamps
    end

    add_index :candidates, :name, unique: true
  end
end
