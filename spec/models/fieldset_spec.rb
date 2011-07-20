require 'spec_helper'
include DynamicFieldsets
  
describe Fieldset do
  include FieldsetHelper

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
      @fieldset.parent_fieldset = Fieldset.new
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
      @root_fieldset = Fieldset.new( valid_root_attributes )
      @child_fieldset = Fieldset.new( valid_child_attributes )
    end
    
    it "should respond to roots scope" do
      Fieldset.should respond_to :roots
    end
    
    it "should return fieldsets with no parent fieldset" do
      pending('requires a database query..')
      roots = Fieldset.roots
      roots.select{ |f| f.parent_fieldset.nil? }.should have(1).fieldset
    end
    
    it "should not return fieldsets with a parent fieldset" do
      pending('requires a database query..')
      roots = Fieldset.roots
      roots.select{ |f| !f.parent_fieldset.nil? }.should have(0).fieldset
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
      
      @field2 = mock_model Field
      @field2.stub!(:id).and_return 2
      @field2.stub!(:order_num).and_return 2
      @field2.stub!(:name).and_return 'a-field'
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
