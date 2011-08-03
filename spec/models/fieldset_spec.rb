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

  it "should respond to parent_fieldsets" do 
    Fieldset.new.should respond_to :parent_fieldsets
  end

  it "should respond to child_fields" do
    Fieldset.new.should respond_to :child_fields
  end

  it "should respond to child_fieldsets" do
    Fieldset.new.should respond_to :child_fieldsets
  end
  
  describe "validations" do
    before(:each) do
      @fieldset = Fieldset.new
    end

    it "should be valid" do
      @fieldset.attributes = valid_attributes
      @fieldset.nkey = "top_level_nkey"
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
      Fieldset.create(valid_attributes)
      @fieldset.attributes = valid_attributes
      @fieldset.should have(1).error_on(:nkey)
    end
  end

  describe "roots scope" do
    before(:each) do
      # we could stub this one but I am not convinced the polymorphic relationships actaully work
      @root_fieldset = Fieldset.new( valid_attributes )
      @root_fieldset.save

      @child_fieldset = Fieldset.new( valid_attributes )
      @child_fieldset.nkey = "something_else" # need to pass validations
      @child_fieldset.save

      @fieldset_children = FieldsetChild.new(:child => @child_fieldset, :fieldset => @root_fieldset, :order_num => 1)
      @fieldset_children.save
    end
    
    it "should respond to roots scope" do
      Fieldset.should respond_to :roots
    end
    
    it "should return fieldsets with no parent fieldset" do
      roots = Fieldset.roots
      roots.each do |root|
        root.parent_fieldsets.should be_empty
      end
    end
    
    it "should not return fieldsets with a parent fieldset" do
      roots = Fieldset.roots
      roots.should_not include @child_fieldset
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
      pending "Waiting on updates to the fieldset child system"
      @root_fieldset = Fieldset.new( valid_attributes )
      @root_fieldset.stub!(:id).and_return(1)
      
      @child_fieldset = mock_model Fieldset
      @child_fieldset.stub!(:id).and_return 2
      @cfs = FieldsetChild.new(:child => @child_fieldset, :fieldset => @root_fieldset, :order_num => 1)
      Fieldset.stub!(:find_by_id).with(2).and_return(@child_fieldset)
      
      @field1 = mock_model Field
      @field1.stub!(:id).and_return 1
      @field1.stub!(:enabled?).and_return true
      @cf1 = FieldsetChild.new(:child => @field1, :fieldset => @root_fieldset, :order_num => 2)
      Field.stub!(:find_by_id).with(1).and_return(@child_fieldset)
      
      @field2 = mock_model Field
      @field2.stub!(:id).and_return 2
      @field2.stub!(:enabled?).and_return false
      @cf2 = FieldsetChild.new(:child => @field2, :fieldset => @root_fieldset)
      Field.stub!(:find_by_id).with(2).and_return(@child_fieldset)
      
      @root_fieldset_children = [@cfs, @cf1, @cf2]
      @root_fieldset.stub!(:fieldset_children).and_return(@root_fieldset_children)
    end
    
    it "should respond to children" do
      @root_fieldset.should respond_to :children
    end
    
    it "should call fieldset children" do
      @root_fieldset.should_receive(:fieldset_children).and_return(@root_fieldset_children)
      children = @root_fieldset.children
    end

    it "should return a mixture of fieldsets and fields" do
      children = @root_fieldset.children
      children.should include @field1
      children.should include @child_fieldset
    end

    it "should not include disabled fields" do
      children = @root_fieldset.children
      children.should_not include @field2
    end
    
    it "should maintain the order of the children regardless of class" do
      children = @root_fieldset.children
      children.first.should == @child_fieldset
      children.last.should == @field1
    end
  end
  
end
