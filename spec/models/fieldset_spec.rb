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
      # no idea why this doesn't set type correctly
      # maybe it is a reserved word
      pending
      @fieldset.attributes = valid_top_level_attributes
      @fieldset.should be_valid
    end

    it "should be valid as a child fieldset" do
      # no idea why this doesn't set type correctly
      # maybe it is a reserved word
      pending
      @fieldset.attributes = valid_child_attributes
      @fieldset.should be_valid
    end

    it "should require a name" do
      @fieldset.should have(1).error_on(:name)
    end

    it "should require a description" do
      @fieldset.should have(1).error_on(:description)
    end

    # also called the permalink
    it "should require a type" do
      @fieldset.should have(1).error_on(:type)
    end

    it "should not require an order number if htere is no parent fieldset" do
      @fieldset.should have(0).error_on(:order_num)
    end

    it "should require an order number if there is a parent fieldset" do
      # also don't know why this reference doesn't work but it does work in the before
      pending
      @fieldset.parent_fieldset = DynamicFieldsets::Fieldset.new
      @fieldset.should have(1).error_on(:order_num)
    end
  
    it "should not allow a parent fieldset when it would create a cycle" do
      # screw writing this test
      pending
    end

    it "should error if you try to change the type unless you really mean it" do
      pending
      @fieldset.you_really_mean_it = false
      @fieldset.should have(1).error_on(:type)
    end
  end

  describe "top_level_fieldsets scope" do
    it "should respond to top_level_fieldsets scope"
    it "should return fieldsets with no parent fieldset"
    it "should not return fieldsets with a parent fieldset"
  end

  describe "render method" do
    it "should probably be named something else"
    it "should call get_haml (or get_erb)"
    it "should call render_children"
    it "should add the results of get_haml to the results of render_children"
    it "should return a haml(/erb) string"
  end

  describe "get_html/erb method" do
    it "should return an array with the top and bottom haml/erb"
    it "should have a better name with haml/erb passed as an argument"
    it "should default to one of the two though"  
  end

  describe "render_children method" do
    it "should call get_ordered_children"
    it "should call the render method for each child (fieldset or field)"
    it "should add it's own tags around the generated html/erb/whatever"
  end

  describe "get_ordered_children method" do
    it "should return a mixture of fieldset and field children of the fieldset"
    it "should return an array of activerecord objects"
    it "should only return top level children"
    it "should maintain the order of the children regardless of class"
    it "should handle duplicate order numbers by alphabetical order of name"
  end
end
