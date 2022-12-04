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

ActiveRecord::Schema[7.0].define(version: 2022_12_04_174611) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "doc_collection_memberships", id: :serial, force: :cascade do |t|
    t.integer "doc_id"
    t.integer "doc_collection_id"
    t.index ["doc_id", "doc_collection_id"], name: "index_doc_collection_m_on_doc_id_and_doc_collection_id", unique: true
  end

  create_table "doc_collections", id: :serial, force: :cascade do |t|
    t.string "slug", null: false
    t.datetime "generated_at", precision: nil
    t.datetime "uploaded_at", precision: nil
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "generated_with"
    t.index ["slug"], name: "index_doc_collections_on_slug", unique: true
  end

  create_table "docs", id: :serial, force: :cascade do |t|
    t.string "tag"
    t.string "slug", null: false
    t.integer "project_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["slug"], name: "index_docs_on_slug", unique: true
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "projects", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "git"
    t.string "slug", null: false
    t.json "tags", default: {}
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.text "links", default: [], null: false, array: true
    t.index ["slug"], name: "index_projects_on_slug", unique: true
  end

end
