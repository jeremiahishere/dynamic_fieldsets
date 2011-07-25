class AddInformationForm < ActiveRecord::Migration
  def self.up
    create_table :information_forms do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :information_forms
  end
end
