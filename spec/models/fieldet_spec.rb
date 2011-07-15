require 'spec_helper'

describe DynamicFieldset::Fieldset do

  it "should respond to child_fields"
  it "should respond to child_fieldsets"
  
  describe "validations" do
    before(:each) do
      @fieldset = DynamicFieldset::Fielset.new
    end

    it "should require a name"
    it "should require a description"
    # also called the permalink
    it "should require a type"
    it "should have an order number if there is a parent fieldset"
    it "should not allow a parent fieldset when it would create a cycle"
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
