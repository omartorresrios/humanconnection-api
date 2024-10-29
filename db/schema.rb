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

ActiveRecord::Schema[7.1].define(version: 2024_10_26_122335) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "explorations", force: :cascade do |t|
    t.text "text"
    t.text "sources", default: [], array: true
    t.text "shared_exploration_ids", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.text "similar_exploration_ids", default: [], array: true
    t.index ["user_id"], name: "index_explorations_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "recipient_id"
    t.integer "actor_id"
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "exploration_id"
    t.index ["actor_id"], name: "index_notifications_on_actor_id"
    t.index ["exploration_id"], name: "index_notifications_on_exploration_id"
    t.index ["recipient_id"], name: "index_notifications_on_recipient_id"
  end

  create_table "users", force: :cascade do |t|
    t.text "fullname"
    t.text "city"
    t.text "bio"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: ""
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "google_id"
    t.text "picture"
    t.text "fcm_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["google_id"], name: "index_users_on_google_id", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "explorations", "users"
  add_foreign_key "notifications", "explorations"
end
