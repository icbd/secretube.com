# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_02_08_123010) do

  create_table "machines", force: :cascade do |t|
    t.string "uuid", null: false
    t.text "description"
    t.text "public_key"
    t.text "private_key"
    t.string "ipv4", null: false
    t.string "ipv6"
    t.integer "max_support_amount", default: 100
    t.integer "count_of_channels", default: 0
    t.integer "admin_user_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_machines_on_deleted_at"
    t.index ["ipv4"], name: "index_machines_on_ipv4"
    t.index ["ipv6"], name: "index_machines_on_ipv6"
    t.index ["uuid"], name: "index_machines_on_uuid"
  end

  create_table "users", force: :cascade do |t|
    t.string "uuid", null: false
    t.string "email", null: false
    t.string "password_digest"
    t.string "nickname"
    t.boolean "email_valid", default: false
    t.string "remember_me_token"
    t.string "forgot_pswd_token"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email"
    t.index ["uuid"], name: "index_users_on_uuid"
  end

end
