# frozen_string_literal: true

class CreateVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :votes, id: false do |t|
      t.string :id, primary_key: true
      t.string :user_id, null: false
      t.string :candidate_id, null: false

      t.timestamps
    end

    add_foreign_key :votes, :users
    add_foreign_key :votes, :candidates
    add_index :votes, [:user_id, :candidate_id], unique: true
  end
end
