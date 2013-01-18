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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130118163115) do

  create_table "apartments", :force => true do |t|
    t.string   "title"
    t.integer  "rent"
    t.integer  "deposit"
    t.string   "size"
    t.integer  "floor"
    t.datetime "start_date"
    t.datetime "end_date"
    t.text     "html_description"
    t.integer  "code"
    t.string   "image_src"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rating",           :default => 0
    t.integer  "score"
    t.string   "location"
    t.float    "lat"
    t.float    "lng"
    t.boolean  "contacted",        :default => false
    t.boolean  "rejected",         :default => false
    t.integer  "status",           :default => 0
  end

  create_table "apartments_features", :id => false, :force => true do |t|
    t.integer "apartment_id"
    t.integer "feature_id"
  end

  create_table "appointments", :force => true do |t|
    t.integer  "apartment_id"
    t.datetime "datetime"
    t.string   "reference_person"
    t.text     "notes"
  end

  create_table "comments", :force => true do |t|
    t.integer  "apartment_id"
    t.integer  "user_id"
    t.text     "text"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "contact_infos", :force => true do |t|
    t.integer "apartment_id"
    t.string  "type"
    t.string  "value"
  end

  create_table "features", :force => true do |t|
    t.string "description"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "name"
    t.boolean  "admin",                  :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
