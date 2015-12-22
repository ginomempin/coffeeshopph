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

ActiveRecord::Schema.define(version: 20151214124302) do

  create_table "customers", force: :cascade do |t|
    t.integer  "server_id"
    t.integer  "table_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "customers", ["server_id", "table_id"], name: "index_customers_on_server_id_and_table_id", unique: true
  add_index "customers", ["server_id"], name: "index_customers_on_server_id"
  add_index "customers", ["table_id"], name: "index_customers_on_table_id"

  create_table "orders", force: :cascade do |t|
    t.string   "name"
    t.decimal  "price",      precision: 7, scale: 2, default: 0.0,   null: false
    t.integer  "quantity",                           default: 0,     null: false
    t.boolean  "served",                             default: false
    t.integer  "table_id"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
  end

  add_index "orders", ["table_id", "created_at"], name: "index_orders_on_table_id_and_created_at"
  add_index "orders", ["table_id"], name: "index_orders_on_table_id"

  create_table "promos", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "code",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "promos", ["code"], name: "index_promos_on_code", unique: true

  create_table "tables", force: :cascade do |t|
    t.string   "name"
    t.integer  "max_persons", default: 0,     null: false
    t.integer  "num_persons", default: 0,     null: false
    t.boolean  "occupied",    default: false
    t.integer  "total_bill",  default: 0,     null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",                  default: false
    t.string   "activation_digest"
    t.boolean  "activated",              default: false
    t.datetime "activated_at"
    t.string   "password_reset_digest"
    t.datetime "password_reset_sent_at"
    t.string   "picture"
    t.string   "authentication_token",   default: ""
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
