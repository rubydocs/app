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

ActiveRecord::Schema.define(version: 20180902103945) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "doc_collection_memberships", force: :cascade do |t|
    t.integer "doc_collection_id"
    t.integer "doc_id"
  end

  add_index "doc_collection_memberships", ["doc_id", "doc_collection_id"], name: "index_doc_collection_m_on_doc_id_and_doc_collection_id", unique: true, using: :btree

  create_table "doc_collections", force: :cascade do |t|
    t.datetime "created_at"
    t.text     "file_paths",     default: [], null: false, array: true
    t.datetime "generated_at"
    t.string   "generated_with"
    t.string   "slug",                        null: false
    t.datetime "updated_at"
    t.datetime "uploaded_at"
  end

  add_index "doc_collections", ["slug"], name: "index_doc_collections_on_slug", unique: true, using: :btree

  create_table "docs", force: :cascade do |t|
    t.datetime "created_at"
    t.integer  "project_id"
    t.string   "slug",       null: false
    t.string   "tag"
    t.datetime "updated_at"
  end

  add_index "docs", ["slug"], name: "index_docs_on_slug", unique: true, using: :btree

  create_table "projects", force: :cascade do |t|
    t.datetime "created_at"
    t.string   "git"
    t.text     "links",      default: [], null: false, array: true
    t.string   "name"
    t.string   "slug",                    null: false
    t.json     "tags",       default: {}
    t.datetime "updated_at"
  end

  add_index "projects", ["slug"], name: "index_projects_on_slug", unique: true, using: :btree

end
