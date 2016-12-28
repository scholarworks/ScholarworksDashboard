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

ActiveRecord::Schema.define(version: 20161228140840) do

  create_table "bitstreams", force: :cascade do |t|
    t.integer "item_id"
    t.string  "name"
    t.integer "size_bytes", limit: 12
    t.boolean "deleted"
    t.index ["item_id"], name: "index_bitstreams_on_item_id"
  end

  create_table "bots", force: :cascade do |t|
    t.string "ip_addr"
  end

  create_table "collections", force: :cascade do |t|
    t.integer "community_id"
    t.string  "name"
    t.index ["community_id"], name: "index_collections_on_community_id"
  end

  create_table "communities", force: :cascade do |t|
    t.integer "parent_id"
    t.string  "name"
    t.index ["parent_id"], name: "index_communities_on_parent_id"
  end

  create_table "events", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "communty_id"
    t.integer  "collection_id"
    t.string   "session_id"
    t.string   "ip_addr"
    t.string   "event_type"
    t.string   "event_class"
    t.string   "source"
    t.datetime "event_date"
    t.integer  "item_id"
    t.integer  "bitstream_id"
    t.boolean  "isbot"
    t.index ["bitstream_id"], name: "index_events_on_bitstream_id"
    t.index ["collection_id"], name: "index_events_on_collection_id"
    t.index ["communty_id"], name: "index_events_on_communty_id"
    t.index ["event_date", "event_type", "isbot"], name: "index_events_on_event_date_and_event_type_and_isbot"
    t.index ["event_date", "isbot"], name: "index_events_on_event_date_and_isbot"
    t.index ["event_date"], name: "index_events_on_event_date"
    t.index ["event_type"], name: "index_events_on_event_type"
    t.index ["item_id"], name: "index_events_on_item_id"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "items", force: :cascade do |t|
    t.integer "collection_id"
    t.string  "handle"
    t.index ["collection_id"], name: "index_items_on_collection_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
  end

end
