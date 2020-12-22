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

ActiveRecord::Schema.define(version: 2020_12_22_171322) do

  create_table "parcel_types", force: :cascade do |t|
    t.string "name"
    t.boolean "calculate_by_weight"
    t.boolean "calculate_by_dimension"
    t.boolean "double_rate_each_day"
    t.float "fee_rate"
    t.float "weight_conversion"
    t.float "dimension_conversion"
    t.string "currency"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "parcels", force: :cascade do |t|
    t.datetime "import_date"
    t.datetime "export_date"
    t.integer "weight"
    t.integer "width"
    t.integer "length"
    t.integer "height"
    t.boolean "in_stock"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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
  end

end
