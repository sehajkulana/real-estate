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

ActiveRecord::Schema[8.1].define(version: 2026_07_16_173310) do
  create_table "amenities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "icon"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "appointments", force: :cascade do |t|
    t.date "appointment_date"
    t.time "appointment_time"
    t.integer "buyer_id", null: false
    t.datetime "created_at", null: false
    t.text "message"
    t.integer "property_id", null: false
    t.integer "seller_id", null: false
    t.string "status"
    t.datetime "updated_at", null: false
    t.index ["buyer_id"], name: "index_appointments_on_buyer_id"
    t.index ["property_id"], name: "index_appointments_on_property_id"
    t.index ["seller_id"], name: "index_appointments_on_seller_id"
  end

  create_table "favorites", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "property_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["property_id"], name: "index_favorites_on_property_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "is_read"
    t.text "message"
    t.integer "property_id", null: false
    t.integer "receiver_id", null: false
    t.integer "sender_id", null: false
    t.datetime "updated_at", null: false
    t.index ["property_id"], name: "index_messages_on_property_id"
    t.index ["receiver_id"], name: "index_messages_on_receiver_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.boolean "is_read"
    t.string "notification_type"
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "properties", force: :cascade do |t|
    t.text "address"
    t.integer "age_of_property"
    t.decimal "area"
    t.string "area_unit"
    t.integer "balconies"
    t.integer "bathrooms"
    t.integer "bedrooms"
    t.string "city"
    t.string "construction_status"
    t.string "country"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "facing"
    t.boolean "featured"
    t.integer "floor"
    t.string "furnished"
    t.decimal "latitude"
    t.string "listing_type"
    t.decimal "longitude"
    t.string "ownership"
    t.integer "parking"
    t.string "pincode"
    t.decimal "price"
    t.string "property_type"
    t.integer "seller_id", null: false
    t.string "state"
    t.string "status"
    t.string "title"
    t.integer "total_floors"
    t.datetime "updated_at", null: false
    t.integer "views"
    t.index ["seller_id"], name: "index_properties_on_seller_id"
  end

  create_table "property_amenities", force: :cascade do |t|
    t.integer "amenity_id", null: false
    t.datetime "created_at", null: false
    t.integer "property_id", null: false
    t.datetime "updated_at", null: false
    t.index ["amenity_id"], name: "index_property_amenities_on_amenity_id"
    t.index ["property_id"], name: "index_property_amenities_on_property_id"
  end

  create_table "property_images", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "image_url"
    t.boolean "is_cover"
    t.integer "property_id", null: false
    t.datetime "updated_at", null: false
    t.index ["property_id"], name: "index_property_images_on_property_id"
  end

  create_table "property_inquiries", force: :cascade do |t|
    t.integer "buyer_id", null: false
    t.datetime "created_at", null: false
    t.string "email"
    t.text "message"
    t.string "name"
    t.string "phone"
    t.integer "property_id", null: false
    t.integer "seller_id", null: false
    t.datetime "updated_at", null: false
    t.index ["buyer_id"], name: "index_property_inquiries_on_buyer_id"
    t.index ["property_id"], name: "index_property_inquiries_on_property_id"
    t.index ["seller_id"], name: "index_property_inquiries_on_seller_id"
  end

  create_table "reports", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "property_id", null: false
    t.string "reason"
    t.integer "reported_by_id", null: false
    t.string "status"
    t.datetime "updated_at", null: false
    t.index ["property_id"], name: "index_reports_on_property_id"
    t.index ["reported_by_id"], name: "index_reports_on_reported_by_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.text "comment"
    t.datetime "created_at", null: false
    t.integer "property_id", null: false
    t.integer "rating"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["property_id"], name: "index_reviews_on_property_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.text "address"
    t.string "city"
    t.string "country"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "first_name"
    t.boolean "is_verified"
    t.string "last_name"
    t.string "password_digest"
    t.string "phone"
    t.string "pincode"
    t.string "profile_image"
    t.string "role"
    t.string "state"
    t.string "status"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "appointments", "buyers"
  add_foreign_key "appointments", "properties"
  add_foreign_key "appointments", "sellers"
  add_foreign_key "favorites", "properties"
  add_foreign_key "favorites", "users"
  add_foreign_key "messages", "properties"
  add_foreign_key "messages", "receivers"
  add_foreign_key "messages", "senders"
  add_foreign_key "notifications", "users"
  add_foreign_key "properties", "sellers"
  add_foreign_key "property_amenities", "amenities"
  add_foreign_key "property_amenities", "properties"
  add_foreign_key "property_images", "properties"
  add_foreign_key "property_inquiries", "buyers"
  add_foreign_key "property_inquiries", "properties"
  add_foreign_key "property_inquiries", "sellers"
  add_foreign_key "reports", "properties"
  add_foreign_key "reports", "reported_bies"
  add_foreign_key "reviews", "properties"
  add_foreign_key "reviews", "users"
end
