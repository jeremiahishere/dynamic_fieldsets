require 'spec_helper'
include DynamicFieldsets

describe DependencyClause do
  it "should respond to dependency_group" do
    DependencyClause.new.should respond_to :dependency_group
  end
  
  it "should respond to dependencies" do
    DependencyClause.new.should respond_to :dependencies
  end

  describe "validations" do
    before(:each) do
      @clause = DependencyClause.new
    end

    it "should be valid" do
      @clause.dependency_group_id = 1
      @clause.should be_valid
    end

    it "should require a dependency group" do
      @clause.should have(1).error_on(:dependency_group_id)
    end
  end

  describe "evaluate" do
    before(:each) do
      @clause = DependencyClause.new
      @dependency = mock_model Dependency
      @clause.stub!(:dependencies).and_return([@dependency])
    end

    it "should return true if at least one of the dependencies evaluateds to true" do
      @dependency.stub!(:evaluate).and_return(true)
      @clause.evaluate.should be_true
    end

    it "should return false if none of the dependencies evaluatue to true" do
      @dependency.stub!(:evaluate).and_return(false)
      @clause.evaluate.should be_false
    end
  end
end
