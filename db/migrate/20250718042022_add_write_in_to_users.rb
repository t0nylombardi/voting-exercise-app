# frozen_string_literal: true

class AddWriteInToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :write_in_id, :string
    add_foreign_key :users, :candidates, column: :write_in_id
    add_index :users, :write_in_id
  end
end
