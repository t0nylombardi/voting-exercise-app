# frozen_string_literal: true

class CreateParticipations < ActiveRecord::Migration[7.0]
  def change
    create_table :participations, id: false do |t|
      t.string :id, primary_key: true
      t.string :user_id, null: false
      t.boolean :has_voted, default: false
      t.boolean :has_written_in, default: false
      t.datetime :voted_at
      t.string :device_type

      t.timestamps
    end

    add_index :participations, :user_id, unique: true
    add_foreign_key :participations, :users
  end
end
