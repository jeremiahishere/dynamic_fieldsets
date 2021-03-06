require 'spec_helper'

describe DynamicFieldsets::Dependency do
  include DependencyHelper
  before(:each) do
    pending "total rewrite"
  end


  it "should respond to fieldset_child" do
    DynamicFieldsets::Dependency.new.should respond_to :fieldset_child
  end

  it "should respond to dependency_clause" do
    DynamicFieldsets::Dependency.new.should respond_to :dependency_clause
  end

  describe "validations" do

    before(:each) do
      @dependency = DynamicFieldsets::Dependency.new
    end

    it "should be valid" do
      @dependency.attributes = valid_attributes
      @dependency.should be_valid
    end

    it "should have a fieldset_child_id" do
      @dependency.should have(1).error_on(:fieldset_child_id)
    end

    it "should not require a dependency_clause_id" do
      #@dependency.should have(1).error_on(:dependency_clause_id)
      @dependency.should have(0).error_on(:dependency_clause_id)
    end

    it "should have a relationship limited to allowable values" do
      @dependency.relationship = "equals"
      @dependency.should have(0).error_on(:relationship)
    end

    it "should error when relationship is not one of the allowable values" do
      @dependency.relationship = "invalid relationship"
      @dependency.should have(1).error_on(:relationship)
    end
  end

  describe "evaluate" do
    before(:each) do
      @fieldset_child = DynamicFieldsets::FieldsetChild.new
      @fieldset_child.stub!(:id).and_return(100)
      @dependency = DynamicFieldsets::Dependency.new
      @dependency.attributes = valid_attributes
      @input_hash = {100 => "test value"}
    end

    it "should take a hash's input" do
      lambda{@dependency.evaluate(@input_hash)}.should_not raise_error
    end

    it "should return true when input matches requirements" do
      @dependency.stub!(:process_relationship).and_return(true)
      @dependency.evaluate(@input_hash).should be_true
    end

    it "should return false when input does not match requirements" do
      @dependency.stub!(:process_relationship).and_return(false)
      @dependency.evaluate(@input_hash).should be_false
    end

    it "should return false when key pairing does not exist" do
      @dependency.stub!(:process_relationship).and_return(false)
      @dependency.evaluate({1 => "test_value"}).should be_false
    end
 
  end

  describe "relationship_list" do
    it "should return an array" do
      @dependency = DynamicFieldsets::Dependency.new
      @dependency.attributes = valid_attributes
      @dependency.relationship_list.should be_an_instance_of Array
    end
  end

  describe "process_relationship" do
    before(:each) do
      @dependency = DynamicFieldsets::Dependency.new
      @dependency.attributes = valid_attributes
      @dependency.value = "test string"
    end

    it "should take a string as input" do
      input_value = "test string"
      lambda{@dependency.process_relationship(input_value)}.should_not raise_error
    end

    it "should return true if the value and input_value are equal and relatinship is equal" do
      @dependency.relationship = "equals"
      input_value = "test string"
      @dependency.process_relationship(input_value).should be_true
    end

    it "should return false if the value and input value are not equal and relationship is equal" do
      @dependency.relationship = "equals"
      input_value = "not test string"
      @dependency.process_relationship(input_value).should be_false
    end

    it "should return true if the value and input_value are not equal and relationship is not equal" do
      @dependency.relationship = "not equals"
      input_value = "not test string"
      @dependency.process_relationship(input_value).should be_true
    end

    it "should return false if the value and input_value are equal and relationship is not equal" do
      @dependency.relationship = "not equals"
      input_value = "test string"
      @dependency.process_relationship(input_value).should be_false
    end

    it "should return true if the value is within the input_value array and relationship is includes" do
      @dependency.relationship = "includes"
      input_value = ["test string"]
      @dependency.process_relationship(input_value).should be_true 
    end

    it "should return false if the value is not within the input_value array and relationship is includes" do
      @dependency.relationship = "includes"
      input_value = ["a"]
      @dependency.process_relationship(input_value).should be_false
    end

    it "should return true if the value is not within the input_value array and relationship is not includes" do
      @dependency.relationship = "not includes"
      input_value = ["a"]
      @dependency.process_relationship(input_value).should be_true
    end

    it "should return false if the value is within the input_value array and relationship is not includes" do
      @dependency.relationship = "not includes"
      input_value = ["test string"]
      @dependency.process_relationship(input_value).should be_false
    end

    it "should return true if the input_value is an empty string and relationship is blank" do
      @dependency.relationship = "blank"
      input_value = ""
      @dependency.process_relationship(input_value).should be_true
    end

    it "should return false if the input_value is not an empty string and relationship is blank" do
      @dependency.relationship = "blank"
      input_value = "test string"
      @dependency.process_relationship(input_value).should be_false
    end

    it "should return true if the input_value is not an empty string and relationship is not blank" do
      @dependency.relationship = "not blank"
      input_value = "test string"
      @dependency.process_relationship(input_value).should be_true
    end

    it "should return false if the input_value is not an empty string and relationship is not blank" do
      @dependency.relationship = "not blank"
      input_value = ""
      @dependency.process_relationship(input_value).should be_false
    end

  end

  describe "to_hash method" do
    it "should have spec tests"
  end
end
