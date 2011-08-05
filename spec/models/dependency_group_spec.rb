require 'spec_helper'
include DynamicFieldsets

describe DependencyClause do
  it "should respond to fieldset_child"
  it "should respond to dependencies"

  describe "validations" do
    it "should be valid"
    it "should require a fieldset_child"
    it "should have at least one dependency clause"
    it "should have a success action"
    it "should have a failure action"
  end

  describe "evaluate" do
    before(:each) do
      @group = DependencyGroup.new
      @clause1 = DependencyClause.new
      @clause2 = DependencyClause.new
      @group.stub!(:dependency_clauses).and_return([@clause1, @clause2])
    end

    it "should return true if all the clauses evaluate to true" do
      @clause1.stub!(:evaluate).and_return(true)
      @clause2.stub!(:evaluate).and_return(true)
      @group.evaluate.should be_true
    end

    it "should return true if one of the clauses evaluates to false" do
      @clause1.stub!(:evaluate).and_return(false)
      @clause2.stub!(:evaluate).and_return(true)
      @group.evaluate.should be_false
    end
  end
end
