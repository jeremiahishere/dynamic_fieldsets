require 'spec_helper'
include DynamicFieldsets

describe Dependency do
  it "should respond to fieldset_child"
  it "should respond to dependency_clauses"

  describe "validations" do
    it "should be valid"
    it "should have a field_id"
    it "should have a value"
    it "should have a relationship"
    it "should have a dependency_clause_id"
    it "should have a relationship limited to allowable values" 
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


    it "should take a string as input" do
      pending "hex is working on this"
      
    end
    it "should call eql? if relationship is 'equals'"
    it "should call !eql? if relationship is 'not equals'"
    it "should call includes? if relationship is 'includes'"
    it "should call !includes? if relationship is 'not includes'"
    it "should call empty? if relationship is 'blank'"
    it "should call !empty? if relationship is 'not blank'"
  end

end
