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
      @fieldset.attributes = valid_root_attributes
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

  describe "roots scope" do
    before(:each) do
      @root_fieldset = DynamicFieldsets::Fieldset.new( valid_root_attributes )
      @child_fieldset = DynamicFieldsets::Fieldset.new( valid_child_attributes )
    end
    
    it "should respond to roots scope" do
      DynamicFieldsets::Fieldset.should have(0).error_on(:roots)
    end
    
    it "should return fieldsets with no parent fieldset" do
      DynamicFieldsets::Fieldset.roots.should include @root_fieldset
    end
    
    it "should not return fieldsets with a parent fieldset" do
      DynamicFieldsets::Fieldset.roots.should_not include @child_fieldset
    end
  end

  describe "collect_markup method" do
    before(:each) do
      @root_fieldset = DynamicFieldsets::Fieldset.new( valid_root_attributes )
      @child_fieldset = DynamicFieldsets::Fieldset.new( valid_child_attributes )
    end
    
    it "should call markup on itself" do
      pending
    end
    
    it "should call collect_markup on its children"
    it "should add the results of markup to the results of its children"
    it "should return an array of haml"
  end

  describe "markup method" do
    before(:each) do
      @fieldset = DynamicFieldsets::Fieldset.new( valid_root_attributes )
    end
    
    it "should respond to markup" do
      @fieldset.should respond_to :markup
    end
    
    it "should return a string of haml" do
      @fieldset.markup.should be_an_instance_of String
    end
  end

  describe "children method" do
    it "should return a mixture of fieldset and field children of the fieldset"
    it "should return an array of activerecord objects"
    it "should only return top level children"
    it "should maintain the order of the children regardless of class"
    it "should handle duplicate order numbers by alphabetical order of name"
  end
end
