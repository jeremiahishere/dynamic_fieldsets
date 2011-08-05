require 'spec_helper'
include DynamicFieldsets
  
describe Fieldset do
  include FieldsetHelper

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

  describe "root? method" do
    before(:each) do
      @fieldset = Fieldset.new
    end

    it "should call parent fieldsets" do  
      @fieldset.should_receive(:parent_fieldsets).and_return([])
      @fieldset.root?
    end

    it "should return true if parent fieldsets is empty" do
      @fieldset.stub!(:parent_fieldsets).and_return([])
      @fieldset.root?.should be_true
    end
    it "should return false if parent fieldsets is not empty" do
      @fieldset.stub!(:parent_fieldsets).and_return(["some object goes here"])
      @fieldset.root?.should be_false
    end
  end

  describe "parent_fieldset_list static method" do
    it "should include values for any fieldset" do
      fieldset = Fieldset.new(:name => "parent_fieldset_list test", :nkey => "parent_fieldset_list_test")
      fieldset.save(:validate => false)
      DynamicFieldsets::Fieldset.parent_fieldset_list.should include [fieldset.name, fieldset.id]
    end
  end

  # gave up on stubs and mocks on this one due to how the data is constantized
  describe "children method" do
    before(:each) do
      @root_fieldset = Fieldset.new( valid_attributes )
      @root_fieldset.stub!(:id).and_return(1234)
      
      @child_fieldset = Fieldset.new( valid_attributes )
      @child_fieldset.nkey = "child_fieldset"
      @child_fieldset.save
      @cfs = FieldsetChild.new(:child => @child_fieldset, :fieldset => @root_fieldset, :order_num => 1)
      
      @field1 = Field.new(
        :name => "Test field name",
        :label => "Test field label",
        :field_type => "textfield",
        :required => true,
        :enabled => true)
      @field1.save
      @cf1 = FieldsetChild.new(:child => @field1, :fieldset => @root_fieldset, :order_num => 2)
      
      @field2 = Field.new(
        :name => "Test field name",
        :label => "Test field label",
        :field_type => "textfield",
        :required => true,
        :enabled => false)
      @field2.save
      @cf2 = FieldsetChild.new(:child => @field2, :fieldset => @root_fieldset, :order_num => 3)
      
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
