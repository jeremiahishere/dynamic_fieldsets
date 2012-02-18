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

ActiveRecord::Schema.define(:version => 20120213211033) do

  create_table "dynamic_fieldsets_dependencies", :force => true do |t|
    t.integer  "fieldset_child_id"
    t.string   "value"
    t.string   "relationship"
    t.integer  "dependency_clause_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dynamic_fieldsets_dependencies", ["dependency_clause_id"], :name => "df_d_dependency_clause_id"
  add_index "dynamic_fieldsets_dependencies", ["fieldset_child_id"], :name => "df_d_fieldset_child_id"

  create_table "dynamic_fieldsets_dependency_clauses", :force => true do |t|
    t.integer  "dependency_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dynamic_fieldsets_dependency_clauses", ["dependency_group_id"], :name => "df_dc_dependency_group_id"

  create_table "dynamic_fieldsets_dependency_groups", :force => true do |t|
    t.string   "action"
    t.integer  "fieldset_child_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dynamic_fieldsets_dependency_groups", ["fieldset_child_id"], :name => "df_dg_fieldset_child_id"

  create_table "dynamic_fieldsets_field_defaults", :force => true do |t|
    t.integer  "field_id"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dynamic_fieldsets_field_defaults", ["field_id"], :name => "df_fd_field_id"

  create_table "dynamic_fieldsets_field_html_attributes", :force => true do |t|
    t.integer  "field_id"
    t.string   "attribute_name"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dynamic_fieldsets_field_html_attributes", ["field_id"], :name => "df_fha_field_id"

  create_table "dynamic_fieldsets_field_options", :force => true do |t|
    t.integer  "field_id"
    t.string   "name"
    t.boolean  "enabled",    :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dynamic_fieldsets_field_options", ["field_id"], :name => "df_fo_field_id"

  create_table "dynamic_fieldsets_field_records", :force => true do |t|
    t.integer  "fieldset_associator_id"
    t.integer  "fieldset_child_id"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dynamic_fieldsets_field_records", ["fieldset_associator_id"], :name => "df_fr_fieldset_associator_id"
  add_index "dynamic_fieldsets_field_records", ["fieldset_child_id"], :name => "df_fr_fieldset_child_id"

  create_table "dynamic_fieldsets_fields", :force => true do |t|
    t.string   "name"
    t.string   "label"
    t.string   "type"
    t.boolean  "required",   :default => false
    t.boolean  "enabled",    :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dynamic_fieldsets_fieldset_associators", :force => true do |t|
    t.integer  "fieldset_id"
    t.integer  "fieldset_model_id"
    t.string   "fieldset_model_type"
    t.string   "fieldset_model_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dynamic_fieldsets_fieldset_associators", ["fieldset_id"], :name => "df_fsa_fieldset_id"
  add_index "dynamic_fieldsets_fieldset_associators", ["fieldset_model_id", "fieldset_model_type"], :name => "df_fsa_polymorphic_model"

  create_table "dynamic_fieldsets_fieldset_children", :force => true do |t|
    t.integer  "fieldset_id"
    t.integer  "child_id"
    t.string   "child_type"
    t.integer  "order_num"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dynamic_fieldsets_fieldset_children", ["child_id", "child_type"], :name => "df_fc_polymorphic_child"
  add_index "dynamic_fieldsets_fieldset_children", ["fieldset_id"], :name => "df_fc_fieldset_id"

  create_table "dynamic_fieldsets_fieldsets", :force => true do |t|
    t.string   "nkey",        :null => false
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dynamic_fieldsets_fieldsets", ["nkey"], :name => "index_dynamic_fieldsets_fieldsets_on_nkey", :unique => true

  create_table "information_forms", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
