# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, id: false do |t|
      t.string :id, primary_key: true
      t.string :email, null: false
      t.string :zip_code, null: false
      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
