class <%= migration_class_name %> < ActiveRecord::Migration
  def self.up
    create_table :dynamic_fieldsets_fieldset_associators do |t|
      t.integer :fieldset_id
      t.integer :fieldset_model_id
      t.string :fieldset_model_type
      t.string :fieldset_model_name

      t.timestamps
    end

    create_table :dynamic_fieldsets_fieldset_children do |t|
      t.integer :fieldset_id
      t.integer :child_id
      t.string :child_type
      t.integer :order_num

      t.timestamps
    end

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
      t.string :field_type, :required => true
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
      
    create_table :dynamic_fieldsets_field_defaults do |t|
      t.integer :field_id
      t.string :value
      
      t.timestamps
    end  
    
    create_table :dynamic_fieldsets_field_html_attributes do |t|
      t.integer :field_id
      t.string :attribute_name, :required => true # couldn't use attribute because it is used by active record
      t.string :value, :required => true

      t.timestamps
    end

    create_table :dynamic_fieldsets_field_records do |t|
      t.integer :fieldset_associator_id
      t.integer :fieldset_child_id
      t.text :value

      t.timestamps
    end

    create_table :dynamic_fieldsets_dependencies do |t|
      t.integer :fieldset_child_id
      t.string :value
      t.string :relationship
      t.integer :dependency_clause_id

      t.timestamps 
    end

    create_table :dynamic_fieldsets_dependency_clauses do |t|
      t.integer :dependency_group_id

      t.timestamps
    end

    create_table :dynamic_fieldsets_dependency_groups do |t|
      t.string :action
      t.integer :fieldset_child_id
      
      t.timestamps
    end
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
