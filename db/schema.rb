# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_07_18_050715) do
  create_table "candidates", id: :string, force: :cascade do |t|
    t.string "name", null: false
    t.integer "votes_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_candidates_on_name"
  end

  create_table "participations", id: :string, force: :cascade do |t|
    t.string "user_id", null: false
    t.boolean "has_voted", default: false
    t.boolean "has_written_in", default: false
    t.datetime "voted_at"
    t.string "device_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_participations_on_user_id", unique: true
  end

  create_table "users", id: :string, force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "zip_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "write_in_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["write_in_id"], name: "index_users_on_write_in_id"
  end

  create_table "votes", id: :string, force: :cascade do |t|
    t.string "user_id", null: false
    t.string "candidate_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "candidate_id"], name: "index_votes_on_user_id_and_candidate_id", unique: true
  end

  add_foreign_key "participations", "users"
  add_foreign_key "users", "candidates", column: "write_in_id"
  add_foreign_key "votes", "candidates"
  add_foreign_key "votes", "users"
end
