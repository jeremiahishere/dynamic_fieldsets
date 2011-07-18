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
      t.string  :label
      t.boolean :required, :default => false
      t.integer :order_num

      t.timestamps
    end
    
  end
  def self.down
    drop_table :fieldsets
    drop_table :fields
  end
end
