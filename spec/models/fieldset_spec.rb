require 'spec_helper'

describe DynamicFieldsets::Fieldset do
  include FieldsetHelper

  it "should respond to parent" do 
    DynamicFieldsets::Fieldset.new.should respond_to :parent
  end

  it "should respond to child_fields" do
    DynamicFieldsets::Fieldset.new.should respond_to :child_fields
  end

  it "should respond to child_fieldsets" do
    DynamicFieldsets::Fieldset.new.should respond_to :child_fieldsets
  end
  
  describe "validations" do
    before(:each) do
      @fieldset = DynamicFieldsets::Fieldset.new
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
      DynamicFieldsets::Fieldset.create(valid_attributes)
      @fieldset.attributes = valid_attributes
      @fieldset.should have(1).error_on(:nkey)
    end
  end

  describe ".roots scope" do
    before(:each) do
      # we could stub this one but I am not convinced the polymorphic relationships actually work
      @root_fieldset = DynamicFieldsets::Fieldset.new( valid_attributes )
      @root_fieldset.save

      @child_fieldset = DynamicFieldsets::Fieldset.new( valid_attributes )
      @child_fieldset.nkey = "something_else" # need to pass validations
      @child_fieldset.save

      @fieldset_children = DynamicFieldsets::FieldsetChild.new(:child => @child_fieldset, :fieldset => @root_fieldset, :order_num => 1)
      @fieldset_children.save
    end
    
    it ": DynamicFieldsets::Fieldset responds to .roots" do
      DynamicFieldsets::Fieldset.should respond_to :roots
    end
    
    it "returns fieldsets with no parent" do
      roots = DynamicFieldsets::Fieldset.roots
      roots.each do |root|
        root.parent.should be_nil
      end
    end
    
    it "does not return fieldsets with a parent" do
      roots = DynamicFieldsets::Fieldset.roots
      roots.should_not include @child_fieldset
    end
  end

  describe ".root? method" do
    before(:each) do
      @fieldset = DynamicFieldsets::Fieldset.new
    end

    it "calls parent" do  
      @fieldset.should_receive(:parent).and_return nil
      @fieldset.root?
    end

    it "returns true if parent is nil" do
      @fieldset.stub!(:parent).and_return nil
      @fieldset.root?.should be_true
    end
    it "returns false if parent is not nil" do
      @fieldset.stub!(:parent).and_return "some object goes here"
      @fieldset.root?.should be_false
    end
  end

  describe "parent_fieldset_list static method" do
    it "should include values for any fieldset" do
      fieldset = DynamicFieldsets::Fieldset.new(:name => "parent_fieldset_list test", :nkey => "parent_fieldset_list_test")
      fieldset.save(:validate => false)
      DynamicFieldsets::Fieldset.parent_fieldset_list.should include [fieldset.name, fieldset.id]
    end
  end

  # gave up on stubs and mocks on this one due to how the data is constantized
  describe "children method" do
    before(:each) do
      @root_fieldset = DynamicFieldsets::Fieldset.new( valid_attributes )
      @root_fieldset.stub!(:id).and_return(1234)
      
      @child_fieldset = DynamicFieldsets::Fieldset.new( valid_attributes )
      @child_fieldset.nkey = "child_fieldset"
      @child_fieldset.save
      @cfs = DynamicFieldsets::FieldsetChild.new(:child => @child_fieldset, :fieldset => @root_fieldset, :order_num => 1)
      
      @field1 = DynamicFieldsets::TextField.new(
        :name => "Test field name",
        :label => "Test field label",
        :required => true,
        :enabled => true)
      @field1.save!
      @cf1 = DynamicFieldsets::FieldsetChild.new(:child => @field1, :fieldset => @root_fieldset, :order_num => 2)
      
      @field2 = DynamicFieldsets::TextField.new(
        :name => "Test field name",
        :label => "Test field label",
        :required => true,
        :enabled => false)
      @field2.save!
      @cf2 = DynamicFieldsets::FieldsetChild.new(:child => @field2, :fieldset => @root_fieldset, :order_num => 3)
      
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
