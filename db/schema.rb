# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140524040313) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "photos", force: true do |t|
    t.string   "filename"
    t.string   "content_type"
    t.integer  "width"
    t.integer  "height"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "exif"
    t.datetime "taken_at"
    t.float    "latitude"
    t.float    "longitude"
    t.text     "comment"
    t.integer  "user_id"
    t.string   "blob_bucket"
    t.string   "blob_key"
  end

  add_index "photos", ["user_id"], name: "index_photos_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "access_key_id"
    t.string   "secret_access_key"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["token"], name: "index_users_on_token", unique: true, using: :btree

end
