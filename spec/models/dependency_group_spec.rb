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
      @group.should be_valid
    end

    it "should require a fieldset_child" do
      @group.should have(1).error_on(:fieldset_child_id)
    end

    it "should have an action" do
      @group.should have(2).error_on(:action)
    end

    it "action should be in Action_list" do
      @group.action = "invalid action"
      @group.should have(1).error_on(:action)
    end
  end

  describe "action_list method" do
    it "should return an hash" do
      DependencyGroup.new.action_list.should be_a_kind_of(Hash)
    end
  end

  describe "dependent_fieldset_children method" do
    before(:each) do
      @group = DependencyGroup.new
      @group.attributes = valid_attributes
      @group.save
      @clause = DependencyClause.create(:dependency_group => @group)
      @dependency = Dependency.create(:value => 5, :relationship => "equals", :dependency_clause_id => @clause.id, :fieldset_child_id => 42)
    end

    it "should return an array" do
      @group.dependent_fieldset_children.should be_a_kind_of(Array)
    end
      
    it "should return fieldset children ids included in the group" do
      #debugger
      @group.dependent_fieldset_children.should include 42
    end

    it "should not return fieldset children ids not included in the group" do
      @group.dependent_fieldset_children.should_not include 41
    end
  end

  describe "get_action method" do
    before(:each) do
      @group = DependencyGroup.new
      @group.stub!(:evaluate).and_return(true)
      @group.action = "show"
    end

    it "should take a hash as input" do
      @group.get_action({}).should_not raise_error ArgumentError
    end

    it "should return the success action if evaluate returns true" do
      @group.get_action({}).should == "show"
    end

    it "should return the failure action if evaluate returns false" do
      @group.stub!(:evaluate).and_return(false)
      @group.get_action({}).should == "hide"
    end
  end

  describe "evaluate method" do
    before(:each) do
      @group = DependencyGroup.new
      @clause1 = DependencyClause.new
      @clause2 = DependencyClause.new
      @group.stub!(:dependency_clauses).and_return([@clause1, @clause2])
      @input_values = {}
    end

    it "should take a hash as input" do
      @group.stub!(:dependency_clauses).and_return([])
      @group.evaluate({}).should_not raise_error ArgumentError
    end

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