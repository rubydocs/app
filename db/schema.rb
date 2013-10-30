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

ActiveRecord::Schema.define(version: 20131029204526) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "doc_collection_associations", force: true do |t|
    t.integer "doc_id"
    t.integer "doc_collection_id"
  end

  add_index "doc_collection_associations", ["doc_collection_id"], name: "index_doc_collection_associations_on_doc_collection_id", using: :btree
  add_index "doc_collection_associations", ["doc_id"], name: "index_doc_collection_associations_on_doc_id", using: :btree

  create_table "doc_collections", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "docs", force: true do |t|
    t.string   "tag"
    t.string   "url"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", force: true do |t|
    t.string   "name"
    t.string   "git"
    t.text     "tags",       default: [], array: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
