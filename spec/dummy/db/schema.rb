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

ActiveRecord::Schema.define(:version => 20110718215812) do

  create_table "fields", :force => true do |t|
    t.integer  "fieldset_id"
    t.string   "label"
    t.boolean  "required",    :default => false
    t.integer  "order_num"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fieldsets", :force => true do |t|
    t.string   "nkey",               :null => false
    t.string   "name"
    t.text     "description"
    t.integer  "parent_fieldset_id"
    t.integer  "order_num"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fieldsets", ["nkey"], :name => "index_fieldsets_on_nkey", :unique => true

end
