class CreateDynamicFieldsetsTables < ActiveRecord::Migration
  def self.up
    create_table :fieldsets do |t|
      t.string  :nkey, :null => false
      t.string  :name
      t.text    :description
      t.integer :parent_fieldset_id
      t.integer :order_num

      t.timestamps
    end
    add_index :fieldsets, :nkey, :unique => true
    
    
    create_table :fields do |t|
      t.integer :fieldset_id
      t.string  :name
      t.string  :label, :required => true
      t.string  :type, :required => true
      t.boolean :required, :default => false
      t.boolean :enabled, :default => true
      t.integer :order_num, :required => true

      t.timestamps
    end
    
  end
  def self.down
    drop_table :fieldsets
    drop_table :fields
  end
end
