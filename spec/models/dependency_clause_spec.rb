require 'spec_helper'

describe DynamicFieldsets::DependencyClause do
  before(:each) do
    pending "total rewrite"
  end

  it "should respond to dependency_group" do
    DynamicFieldsets::DependencyClause.new.should respond_to :dependency_group
  end
  
  it "should respond to dependencies" do
    DynamicFieldsets::DependencyClause.new.should respond_to :dependencies
  end

  describe "validations" do
    before(:each) do
      @clause = DynamicFieldsets::DependencyClause.new
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
      @clause = DynamicFieldsets::DependencyClause.new
      @dependency1 = DynamicFieldsets::Dependency.new
      @dependency2 = DynamicFieldsets::Dependency.new
      @clause.stub!(:dependencies).and_return([@dependency1, @dependency2])
      @evaluate_args = {}
    end

    it "should take a hash as input" do
      @dependency1.stub!(:evaluate).and_return(true)
      @dependency2.stub!(:evaluate).and_return(false)
      @clause.evaluate(@evaluate_args).should_not raise_error ArgumentError
    end

    it "should return true if at least one of the dependencies evaluateds to true" do
      @dependency1.stub!(:evaluate).and_return(true)
      @dependency2.stub!(:evaluate).and_return(false)
      @clause.evaluate(@evaluate_args).should be_true
    end

    it "should return false if none of the dependencies evaluatue to true" do
      @dependency1.stub!(:evaluate).and_return(false)
      @dependency2.stub!(:evaluate).and_return(false)
      @clause.evaluate(@evaluate_args).should be_false
    end
  end
end
