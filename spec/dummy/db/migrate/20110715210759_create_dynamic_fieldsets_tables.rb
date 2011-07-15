class CreateDynamicFieldsetsTables < ActiveRecord::Migration
  def self.up
    create_table :fieldsets do |t|
      t.string :name
      t.text :description
      t.string :type
      t.integer :parent_fieldset_id
      t.integer :order_num

      t.timestamps
    end
  end
  def self.down
    drop_table :fieldsets
  end
end
