require 'spec_helper'
include DynamicFieldsets

describe DependencyClause do
  it "should respond to dependency_group"
  it "should respond to dependencies"

  describe "validations" do
    it "should be valid"
    it "should require a dependency group"
  end

  describe "evaluate" do
    before(:each) do
      @clause = DependencyClause.new
      @dependency1 = Dependency.new
      @dependency2 = Dependency.new
      @clause.stub!(:dependencies).and_return([@dependency1, @dependency2])
    end

    it "should return true if at least one of the dependencies evaluateds to true" do
      @dependency1.stub!(:evaluate).and_return(true)
      @dependency2.stub!(:evaluate).and_return(false)
      @clause.evaluate.should be_true
    end

    it "should return false if none of the dependencies evaluatue to true" do
      @dependency1.stub!(:evaluate).and_return(false)
      @dependency2.stub!(:evaluate).and_return(false)
      @clause.evaluate.should be_false
    end
  end
end
