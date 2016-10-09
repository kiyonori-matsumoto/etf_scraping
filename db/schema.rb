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

ActiveRecord::Schema.define(version: 20161009172139) do

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
    t.string   "issue_code"
  end

  create_table "issues", force: :cascade do |t|
    t.integer  "daily_id"
    t.string   "name"
    t.string   "code"
    t.string   "url"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "company"
    t.integer  "base_unit",      default: 1
    t.integer  "trade_unit",     default: 1
    t.string   "country",        default: "", null: false
    t.string   "etf_type",       default: "", null: false
    t.string   "portfolio_type"
  end

  add_index "issues", ["code"], name: "index_issues_on_code", unique: true

  create_table "user_issues", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "issue_code"
    t.decimal  "price"
    t.integer  "num"
    t.datetime "bought_day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_issues", ["issue_code"], name: "index_user_issues_on_issue_code"

  create_table "user_settings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "yearly_deposit"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.datetime "start_date"
    t.integer  "japan_issue",     default: 0
    t.integer  "japan_reit",      default: 0
    t.integer  "japan_bond",      default: 0
    t.integer  "developed_issue", default: 0
    t.integer  "developed_reit",  default: 0
    t.integer  "developed_bond",  default: 0
    t.integer  "emerging_issue",  default: 0
    t.integer  "emerging_reit",   default: 0
    t.integer  "emerging_bond",   default: 0
    t.integer  "commodity",       default: 0
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.boolean  "admin"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
