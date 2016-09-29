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

ActiveRecord::Schema.define(version: 20160929155433) do

  create_table "dailies", force: :cascade do |t|
    t.decimal  "base_price"
    t.decimal  "end_price"
    t.decimal  "total_assets"
    t.decimal  "total_issued"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "issue_id"
    t.decimal  "start_price"
    t.decimal  "high_price"
    t.decimal  "low_price"
  end

  create_table "issues", force: :cascade do |t|
    t.integer  "daily_id"
    t.string   "name"
    t.string   "code"
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "company"
  end

  add_index "issues", ["code"], name: "index_issues_on_code", unique: true

end
