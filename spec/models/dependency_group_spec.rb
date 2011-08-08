require 'spec_helper'
include DynamicFieldsets

describe DependencyGroup do
  it "should respond to fieldset_child"
  it "should respond to dependencies"

  describe "validations" do
    it "should be valid"
    it "should require a fieldset_child"
    it "should have at least one dependency clause"
    it "should have a success action"
    it "success action should be in action_list"
    it "should have a failure action"
    it "failure action should be in action_list"
  end

  describe "action_list method" do
    it "should return an array"
  end

  describe "dependent_fieldset_children method" do
    it "should return an array"
    it "should return fieldset children ids included in the group"
    it "should not return fieldset children ids not included in the group"
  end

  describe "action method" do
    it "should take a hash as input"
    it "should return the success action if evaluate returns true"
    it "should return the failure action if evaluate returns false"
  end

  describe "evaluate method" do
    before(:each) do
      @group = DependencyGroup.new
      @clause1 = DependencyClause.new
      @clause2 = DependencyClause.new
      @group.stub!(:dependency_clauses).and_return([@clause1, @clause2])
      @input_values = {}
    end

    it "should take a hash as input"

    it "should return true if all the clauses evaluate to true" do
      @clause1.stub!(:evaluate).and_return(true)
      @clause2.stub!(:evaluate).and_return(true)
      @group.evaluate(@input_values).should be_true
    end

    it "should return true if one of the clauses evaluates to false" do
      @clause1.stub!(:evaluate).and_return(false)
      @clause2.stub!(:evaluate).and_return(true)
      @group.evaluate(@input_values).should be_false
    end
  end
end
