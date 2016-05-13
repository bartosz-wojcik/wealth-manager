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

ActiveRecord::Schema.define(version: 20160513061207) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "activation_key"
    t.datetime "activation_expiry"
    t.integer  "status",            default: 0
    t.datetime "last_seen"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "currency_id"
  end

  add_index "accounts", ["currency_id"], name: "index_accounts_on_currency_id", using: :btree

  create_table "asset_categories", force: :cascade do |t|
    t.integer  "asset_type_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "account_id"
  end

  add_index "asset_categories", ["asset_type_id"], name: "index_asset_categories_on_asset_type_id", using: :btree

  create_table "asset_types", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "currencies", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "description"
  end

  create_table "currency_rates", force: :cascade do |t|
    t.string   "pair_name"
    t.integer  "base_currency_id"
    t.integer  "quote_currency_id"
    t.decimal  "current_rate",      precision: 12, scale: 4
    t.datetime "rate_cached_time"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.date     "rate_date"
  end

  create_table "portfolio_changes", force: :cascade do |t|
    t.integer  "portfolio_id"
    t.integer  "currency_id"
    t.integer  "asset_category_id"
    t.decimal  "value",             precision: 20, scale: 2
    t.date     "entered_date"
    t.text     "notes"
    t.boolean  "partial_value",                              default: true
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
  end

  add_index "portfolio_changes", ["asset_category_id"], name: "index_portfolio_changes_on_asset_category_id", using: :btree
  add_index "portfolio_changes", ["currency_id"], name: "index_portfolio_changes_on_currency_id", using: :btree
  add_index "portfolio_changes", ["portfolio_id"], name: "index_portfolio_changes_on_portfolio_id", using: :btree

  create_table "portfolio_net_values", force: :cascade do |t|
    t.integer  "portfolio_id"
    t.integer  "currency_id"
    t.integer  "asset_category_id"
    t.decimal  "value",             precision: 20, scale: 2
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "portfolio_net_values", ["asset_category_id"], name: "index_portfolio_net_values_on_asset_category_id", using: :btree
  add_index "portfolio_net_values", ["currency_id"], name: "index_portfolio_net_values_on_currency_id", using: :btree
  add_index "portfolio_net_values", ["portfolio_id"], name: "index_portfolio_net_values_on_portfolio_id", using: :btree

  create_table "portfolios", force: :cascade do |t|
    t.integer  "account_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "portfolios", ["account_id"], name: "index_portfolios_on_account_id", using: :btree

  add_foreign_key "accounts", "currencies"
  add_foreign_key "currency_rates", "currencies", column: "base_currency_id"
  add_foreign_key "currency_rates", "currencies", column: "quote_currency_id"
end
