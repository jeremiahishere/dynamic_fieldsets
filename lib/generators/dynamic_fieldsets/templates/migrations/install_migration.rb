class <%= migration_class_name %> < ActiveRecord::Migration
  def self.up
    create_table :dynamic_fieldsets_fieldset_associators do |t|
      t.integer :fieldset_id
      t.integer :fieldset_model_id
      t.string :fieldset_model_type
      t.string :fieldset_model_name

      t.timestamps
    end
    add_index :dynamic_fieldsets_fieldset_associators, :fieldset_id, :name => "df_fsa_fieldset_id"
    add_index :dynamic_fieldsets_fieldset_associators, [:fieldset_model_id, :fieldset_model_type], :name => "df_fsa_polymorphic_model"

    create_table :dynamic_fieldsets_fieldset_children do |t|
      t.integer :fieldset_id
      t.integer :child_id
      t.string :child_type
      t.integer :order_num

      t.timestamps
    end
    add_index :dynamic_fieldsets_fieldset_children, :fieldset_id, :name => "df_fc_fieldset_id"
    add_index :dynamic_fieldsets_fieldset_children, [:child_id, :child_type], :name => "df_fc_polymorphic_child"

    create_table :dynamic_fieldsets_fieldsets do |t|
      t.string :nkey, :null => false
      t.string :name
      t.text :description

      t.timestamps
    end
    add_index :dynamic_fieldsets_fieldsets, :nkey, :unique => true
    
    
    create_table :dynamic_fieldsets_fields do |t|
      t.string :name
      t.string :label, :required => true
      t.string :type, :required => true
      t.boolean :required, :default => false
      t.boolean :enabled, :default => true

      t.timestamps
    end
    
    create_table :dynamic_fieldsets_field_options do |t|
      t.integer :field_id
      t.string :name
      t.boolean :enabled, :default => true
    
      t.timestamps
    end
    add_index :dynamic_fieldsets_field_options, :field_id, :name => "df_fo_field_id"
      
    create_table :dynamic_fieldsets_field_defaults do |t|
      t.integer :field_id
      t.string :value
      
      t.timestamps
    end  
    add_index :dynamic_fieldsets_field_defaults, :field_id, :name => "df_fd_field_id"
    
    create_table :dynamic_fieldsets_field_html_attributes do |t|
      t.integer :field_id
      t.string :attribute_name, :required => true # couldn't use attribute because it is used by active record
      t.string :value, :required => true

      t.timestamps
    end
    add_index :dynamic_fieldsets_field_html_attributes, :field_id, :name => "df_fha_field_id"

    create_table :dynamic_fieldsets_field_records do |t|
      t.integer :fieldset_associator_id
      t.integer :fieldset_child_id
      t.text :value

      t.timestamps
    end
    add_index :dynamic_fieldsets_field_records, :fieldset_associator_id, :name => "df_fr_fieldset_associator_id"
    add_index :dynamic_fieldsets_field_records, :fieldset_child_id, :name => "df_fr_fieldset_child_id"

    create_table :dynamic_fieldsets_dependencies do |t|
      t.integer :fieldset_child_id
      t.string :value
      t.string :relationship
      t.integer :dependency_clause_id

      t.timestamps 
    end
    add_index :dynamic_fieldsets_dependencies, :fieldset_child_id, :name => "df_d_fieldset_child_id"
    add_index :dynamic_fieldsets_dependencies, :dependency_clause_id, :name => "df_d_dependency_clause_id"

    create_table :dynamic_fieldsets_dependency_clauses do |t|
      t.integer :dependency_group_id

      t.timestamps
    end
    add_index :dynamic_fieldsets_dependency_clauses, :dependency_group_id, :name => "df_dc_dependency_group_id"

    create_table :dynamic_fieldsets_dependency_groups do |t|
      t.string :action
      t.integer :fieldset_child_id
      
      t.timestamps
    end
    add_index :dynamic_fieldsets_dependency_groups, :fieldset_child_id, :name => "df_dg_fieldset_child_id"
  end

  def self.down
    drop_table :dynamic_fieldsets_fieldsets
    drop_table :dynamic_fieldsets_fieldset_children
    drop_table :dynamic_fieldsets_fields
    drop_table :dynamic_fieldsets_field_options
    drop_table :dynamic_fieldsets_field_defaults
    drop_table :dynamic_fieldsets_field_html_attributes
    drop_table :dynamic_fieldsets_field_records

    drop_table :dynamic_fieldsets_dependencies
    drop_table :dynamic_fieldsets_dependency_clauses
    drop_table :dynamic_fieldsets_dependency_group
  end
end
