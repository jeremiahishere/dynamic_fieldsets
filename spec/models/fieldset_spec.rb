require 'spec_helper'

describe DynamicFieldsets::Fieldset do
  include FieldsetHelper

  it "should respond to child_fields" do
    # pending until fields model is complete
    pending
    fieldset = DynamicFieldsets::Fieldset.new
    fieldset.should respond_to :child_fields
  end

  it "should respond to parent_fieldset" do 
    fieldset = DynamicFieldsets::Fieldset.new
    fieldset.should respond_to :parent_fieldset
  end

  it "should respond to child_fieldsets" do
    fieldset = DynamicFieldsets::Fieldset.new
    fieldset.should respond_to :child_fieldsets
  end
  
  describe "validations" do
    before(:each) do
      @fieldset = DynamicFieldsets::Fieldset.new
    end

    it "should be valid as a top level fieldset" do
      @fieldset.attributes = valid_top_level_attributes
      @fieldset.should be_valid
    end

    it "should be valid as a child fieldset" do
      @fieldset.attributes = valid_child_attributes
      @fieldset.should be_valid
    end

    it "should require a name" do
      @fieldset.should have(1).error_on(:name)
    end

    it "should require a description" do
      @fieldset.should have(1).error_on(:description)
    end

    it "should require an nkey" do # permalink
      @fieldset.should have(1).error_on(:nkey)
    end

    it "should not require an order number if there is no parent fieldset" do
      @fieldset.should have(0).error_on(:order_num)
    end

    it "should require an order number if there is a parent fieldset" do
      @fieldset.parent_fieldset = DynamicFieldsets::Fieldset.new
      @fieldset.should have(1).error_on(:order_num)
    end
  
    it "should not allow a parent fieldset when it would create a cycle" do
      # screw writing this test
      pending
    end

    it "should error if you try to change the nkey unless you really mean it" do
      pending
      @fieldset.you_really_mean_it = false
      @fieldset.should have(1).error_on(:nkey)
    end
  end

  describe "roots scope" do # A Fieldset root has no parents
    before(:each) do
      @fieldset = DynamicFieldsets::Fieldset.new
    end
    
    it "should respond to roots scope" do
      @fieldset.should have(0).error_on(:roots)
    end
    
    it "should return fieldsets with no parent fieldset"
    it "should not return fieldsets with a parent fieldset"
  end

  describe "full_markup method" do
    it "should call get_markup on itself and each field"
    it "should call full_markup on fieldset children"
    it "should add the results of get_markup to the results of fieldset children"
    it "should return an array of haml lines"
  end

  describe "get_markup method" do
    it "should return a string of haml"
  end

  describe "get_ordered_children method" do
    it "should return a mixture of fieldset and field children of the fieldset"
    it "should return an array of activerecord objects"
    it "should only return top level children"
    it "should maintain the order of the children regardless of class"
    it "should handle duplicate order numbers by alphabetical order of name"
  end
end
