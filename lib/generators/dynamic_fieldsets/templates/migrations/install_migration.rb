class <%= migration_class_name %> < ActiveRecord::Migration
  def self.up
    create_table :fieldset_associators do |t|
      t.integer :fieldset_id
      t.integer :fieldset_model_id
      t.string :fieldset_model_type
      t.string :fieldset_model_name

      t.timestamps
    end

    create_table :fieldsets do |t|
      t.string :nkey, :null => false
      t.string :name
      t.text :description
      t.integer :parent_fieldset_id
      t.integer :order_num

      t.timestamps
    end
    add_index :fieldsets, :nkey, :unique => true
    
    
    create_table :fields do |t|
      t.integer :fieldset_id
      t.string :name
      t.string :label, :required => true
      t.string :type, :required => true
      t.boolean :required, :default => false
      t.boolean :enabled, :default => true
      t.integer :order_num, :required => true

      t.timestamps
    end
    
    create_table :field_options do |t|
      t.integer :field_id
      t.string :label
    
      t.timestamps
    end
      
    create_table :field_defaults do |t|
      t.integer :field_id
      t.string :value
      
      t.timestamps
    end  
    
    create_table :field_html_attributes do |t|
      t.integer :field_id
      t.string :attribute_name, :required => true # couldn't use attribute because it is used by active record
      t.string :value, :required => true

      t.timestamps
    end

    create_table :field_records do |t|
      t.integer :fieldset_associator_id
      t.integer :field_id
      t.text :value
    end
  end

  def self.down
    drop_table :fieldsets
    drop_table :fields
    drop_table :field_options
    drop_table :field_defaults
    drop_table :field_html_attributes
    drop_table :field_records
  end
end
