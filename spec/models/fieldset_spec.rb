require 'spec_helper'
include DynamicFieldsets
  
describe Fieldset do
  include FieldsetHelper

  describe "updates for multiple use fields" do
    it "should no longer have a parent fieldset in the model"
    it "should no longer have an order number"
    it "should still be able to tell if it is a top level fieldset"
    it "should get children from the fieldsetchild model"
    it "should have fieldset children and field children"
  end

  it "should respond to fields" do
    fieldset = Fieldset.new
    fieldset.should respond_to :fields
  end

  it "should respond to parent_fieldset" do 
    fieldset = Fieldset.new
    fieldset.should respond_to :parent_fieldset
  end

  it "should respond to child_fieldsets" do
    fieldset = Fieldset.new
    fieldset.should respond_to :child_fieldsets
  end
  
  describe "validations" do
    before(:each) do
      @fieldset = Fieldset.new
    end

    it "should be valid as a top level fieldset" do
      @fieldset.attributes = valid_root_attributes
      @fieldset.nkey = "top_level_nkey"
      @fieldset.should be_valid
    end

    it "should be valid as a child fieldset" do
      @fieldset.attributes = valid_child_attributes
      @fieldset.nkey = "child_level_nkey"
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

    it "should require a unique nkey" do
      Fieldset.create(valid_root_attributes)
      @fieldset.attributes = valid_root_attributes
      @fieldset.should have(1).error_on(:nkey)
    end

    it "should not require an order number if there is no parent fieldset" do
      @fieldset.should have(0).error_on(:order_num)
    end

    it "should require an order number if there is a parent fieldset" do
      @fieldset.parent_fieldset = Fieldset.new
      @fieldset.should have(1).error_on(:order_num)
    end
  
    it "should not allow a parent fieldset when it would create a cycle" do
      fieldset1 = Fieldset.new(:nkey => "fieldset1")
      fieldset2 = Fieldset.new(:parent_fieldset => fieldset1, :nkey => "fieldset2")
      fieldset3 = Fieldset.new(:parent_fieldset => fieldset2, :nkey => "fieldset3")
      fieldset1.parent_fieldset = fieldset3

      fieldset1.should have(1).error_on(:parent_fieldset)
    end
  end

  describe "roots scope" do
    before(:each) do
      @root_fieldset = Fieldset.new( valid_root_attributes )
      @root_fieldset.save

      @child_fieldset = Fieldset.new( valid_child_attributes )
      @child_fieldset.save
    end
    
    it "should respond to roots scope" do
      Fieldset.should respond_to :roots
    end
    
    it "should return fieldsets with no parent fieldset" do
      roots = Fieldset.roots
      roots.select{ |f| f.parent_fieldset.nil? }.should have(1).fieldset
    end
    
    it "should not return fieldsets with a parent fieldset" do
      roots = Fieldset.roots
      roots.select{ |f| !f.parent_fieldset.nil? }.should have(0).fieldset
    end
  end

  describe "parent_fieldset_list static method" do
    it "should include values for any fieldset" do
      fieldset = Fieldset.new(:name => "parent_fieldset_list test", :nkey => "parent_fieldset_list_test")
      fieldset.save(:validate => false)
      DynamicFieldsets::Fieldset.parent_fieldset_list.should include [fieldset.name, fieldset.id]
    end
  end

  describe "children method" do
    before(:each) do
      @root_fieldset = Fieldset.new( valid_root_attributes )
      
      @child_fieldset = mock_model Fieldset
      @child_fieldset.stub!(:id).and_return 2
      @child_fieldset.stub!(:order_num).and_return 1
      @child_fieldset.stub!(:name).and_return
      
      @field1 = mock_model Field
      @field1.stub!(:id).and_return 1
      @field1.stub!(:order_num).and_return 2
      @field1.stub!(:name).and_return 'z-field'
      @field1.stub!(:enabled).and_return true
      
      @field2 = mock_model Field
      @field2.stub!(:id).and_return 2
      @field2.stub!(:order_num).and_return 2
      @field2.stub!(:name).and_return 'a-field'
      @field2.stub!(:enabled).and_return true
      
    end
    
    it "should respond to children" do
      @root_fieldset.should respond_to :children
    end
    
    it "should call fields and return them" do
      @root_fieldset.should_receive(:fields).and_return [@field1]
      @root_fieldset.children.should include @field1
    end
    
    it "should call child_fieldsets and return them" do
      @root_fieldset.should_receive(:child_fieldsets).and_return [@child_fieldset]
      @root_fieldset.children.should include @child_fieldset
    end
    
    it "should return a mixture of fieldsets and fields" do
      @root_fieldset.stub!(:fields).and_return [@field1]
      @root_fieldset.stub!(:child_fieldsets).and_return [@child_fieldset]
      children = @root_fieldset.children
      children.should include @field1
      children.should include @child_fieldset
    end
    
    it "should maintain the order of the children regardless of class" do
      @root_fieldset.stub!(:fields).and_return [@field1]
      @root_fieldset.stub!(:child_fieldsets).and_return [@child_fieldset]
      children = @root_fieldset.children
      children.first.should == @child_fieldset
      children.last.should == @field1
    end
    
    it "should handle duplicate order numbers by alphabetical order of name" do
      @root_fieldset.stub!(:fields).and_return [@field1, @field2]
      children = @root_fieldset.children
      children.first.should == @field2
      children.last.should == @field1
    end
  end
  
end
