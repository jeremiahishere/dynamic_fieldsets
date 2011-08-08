require 'spec_helper'
include DynamicFieldsets

describe Dependency do

  it "should respond to fieldset_child" do
    pending "hex is working on this"
    Dependency.new.should respond_to :fieldset_child
  end

  it "should respond to dependency_clauses" do
    pending "hex is working on this"
    Dependency.new.should respond_to :dependency_clauses
  end

  describe "validations" do
    before(:each) do
      pending "hex is working on this"
      @dependency = Dependency.new
    end

    it "should be valid" do
      pending "hex is working on this"
      @dependency.attributes = valid_attributes
      @dependency.should be_valid
    end

    it "should have a field_id" do
      pending "hex is working on this"
      @dependency.should have(1).error_on(:field_id)
    end

    it "should have a value" do
      pending "hex is working on this"
      @dependency.shoud have(1).error_on(:value)
    end

    it "should have a relationship" do
      pending "hex is working on this"
      @dependency.should have(1).error_on(:relationship)
    end

    it "should have a dependency_clause_id" do
      pending "hex is working on this"
      @dependency.should have(1).error_on(:dependency_clause_id)
    end

    it "should have a relationship limited to allowable values" do
      pending "hex is working on this"
      @dependency.relationship = "invalid relationship"
      @dependnecy.should have(1).error_on(:relationship)
    end
  end

  describe "evaluate" do
    before(:each) do
      pending "hex is working on this"
      @fieldset_child = FieldsetChild.new
      @fieldset_child.stub!(:id).and_return(100)
      @dependency = Dependency.new
      @dependency.fieldset_child = @fieldset_child
      @input_hash = {@fieldset_child.id => "test_value"}
    end

    it "should take a hash's input" do
      pending "hex is working on this"
      @dependency.evaluate(@input_hash).should_not raise_error
    end

    it "should return true when input matches requirements" do
      pending "hex is working on this"
      @dependency.stub!(:process_relationship).and_return(true)
      @dependency.evaluate(@input_hash).should be_true
    end

    it "should return false when input does not match requirements" do
      pending "hex is working on this"
      @dependency.stub!(:process_relationship).and_return(false)
      @dependency.evaluate(@input_hash).should be_false
    end

    it "should return false when key pairing does not exist" do
      pending "hex is working on this"
      @dependency.stub!(:process_relationship).and_return(false)
      @dependency.evaluate({1 => "test_value"}).should be_false
    end
 
  end

  describe "relationship_list" do
    it "should return an array"
  end

  describe "process_relationship" do
    before(:each) do
      pending "hex is working on this"
      @dependency = Dependency.new
      @dependency.value = "test string"
    end

    it "should take a string as input" do
      pending "hex is working on this"
      @dependency.process_relationship(@input_value).should_not raise_error
    end

    it "should return true if the value and input_value are equal and relatinship is equal" do
      pending "hex is working on this"
      @dependency.relationship = "equal"
      input_value = "test string"
      @dependency.process_relationship(input_value).should be_true
    end

    it "should return false if the value and input value are not equal and relationship is equal" do
      pending "hex is working on this"
      @dependency.relationship = "equal"
      input_value = "not test string"
      @dependency.process_relationship(input_value).should be_false
    end

    it "should return true if the value and input_value are not equal and relationship is not equal" do
      pending "hex is working on this"
      @dependency.relationship = "not equal"
      input_value = "not test string"
      @dependency.process_relationship(input_value).should be_true
    end

    it "should return false if the value and input_value are equal and relationship is not equal" do
      pending "hex is working on this"
      @dependency.relationship = "not equal"
      input_value = "test string"
      @dependency.process_relationship(input_value).should be_false
    end

    it "should return true if the value is within the input_value array and relationship is includes" do
      pending "hex is working on this"
      @dependency.relationship = "includes"
      input_value = ["test_string"]
      @dependency.process_relationship(input_value).should be_true 
    end

    it "should return false if the value is not within the input_value array and relationship is includes" do
      pending "hex is working on this"
      @dependency.relationship = "includes"
      input_value = ["a"]
      @dependency.process_relationship(input_value).should be_false
    end

    it "should return true if the value is not within the input_value array and relationship is not includes" do
      pending "hex is working on this"
      @dependency.relationship = "not includes"
      input_value = ["a"]
      @dependency.process_relationship(input_value).should be_true
    end

    it "should return false if the value is within the input_value array and relationship is not includes" do
      pending "hex is working on this"
      @dependency.relationship = "not includes"
      input_value = ["test_string"]
      @dependency.process_relationship(input_value).should be_false
    end

    it "should return true if the input_value is an empty string and relationship is blank" do
      pending "hex is working on this"
      @dependency.relationship = "blank"
      input_value = ""
      @dependency.process_relationship(input_value).should be_true
    end

    it "should return false if the input_value is not an empty string and relationship is blank" do
      pending "hex is working on this"
      @dependency.relationship = "blank"
      input_value = "test string"
      @dependency.process_relationship(input_value).should be_false
    end

    it "should return true if the input_value is not an empty string and relationship is not blank" do
      pending "hex is working on this"
      @dependency.relationship = "not blank"
      input_value = "test string"
      @dependency.process_relationship(input_value).should be_true
    end

    it "should return false if the input_value is not an empty string and relationship is not blank" do
      pending "hex is working on this"
      @dependency.relationship = "not blank"
      input_value = ""
      @dependency.process_relationship(input_value).should be_false
    end

  end

end
