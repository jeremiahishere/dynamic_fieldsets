require 'spec_helper'
include DynamicFieldsets

describe DependencyGroup do
  include DependencyGroupHelper

  it "should respond to fieldset_child" do
    DependencyGroup.new.should respond_to :fieldset_child
  end

  it "should respond to dependency_clauses" do
    DependencyGroup.new.should respond_to :dependency_clauses
  end

  describe "validations" do
    before(:each) do
      @group = DependencyGroup.new
    end

    it "should be valid" do
      @group.attributes = valid_attributes
      pending "not sure how I messed this one up"
      @group.should be_valid
    end

    it "should require a fieldset_child" do
      @group.should have(1).error_on(:fieldset_child)
    end

    it "should have at least one dependency clause"

    it "should have a success action" do
      @group.should have(2).error_on(:success_action)
    end

    it "success action should be in action_list" do
      @group.success_action = "invalid action"
      @group.should have(1).error_on(:success_action)
    end

    it "should have a failure action" do
      @group.should have(2).error_on(:failure_action)
    end

    it "failure action should be in action_list" do
      @group.failure_action = "invalid action"
      @group.should have(1).error_on(:failure_action)
    end
  end

  describe "action_list method" do
    it "should return an array" do
      DependencyGroup.new.action_list.should be_a_kind_of(Array)
    end
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
