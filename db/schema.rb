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

ActiveRecord::Schema.define(version: 2020_12_11_102030) do

  # use single table inheritance
  # keep all products data in the same table and differenciate by it's type
  create_table "products", force: :cascade do |t|
    t.string "type"
    t.string "name"
    t.string "description"
    t.datetime "import_date"
    t.datetime "export_date"
    t.integer "weight"
    t.integer "width"
    t.integer "length"
    t.integer "height"
    t.float "total_fee"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "exported"
  end
end
