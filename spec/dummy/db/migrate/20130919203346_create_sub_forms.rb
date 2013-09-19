class CreateSubForms < ActiveRecord::Migration
  def self.up
    create_table :sub_forms do |t|
      t.string :name
      t.integer :information_form_id

      t.timestamps
    end
  end

  def self.down
    drop_table :sub_forms
  end
end
