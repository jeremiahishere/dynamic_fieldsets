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

  describe "dependency_group_fieldset_chldren method" do
    before(:each) do
      @fieldset_child_1 = FieldsetChild.create(:fieldset_id => 1, :child_id => 1, :child_type => "DynamicFieldsets::Field", :order_num => 1)
      @fieldset_child_2 = FieldsetChild.create(:fieldset_id => 2, :child_id => 2, :child_type => "DynamicFieldsets::Field", :order_num => 2)
      @fieldset_child_3 = FieldsetChild.create(:fieldset_id => 3, :child_id => 3, :child_type => "DynamicFieldsets::Field", :order_num => 3)
      @group = DependencyGroup.create(:fieldset_child => @fieldset_child_3, :action => "show")
      @clause = DependencyClause.create(:dependency_group => @group)
      @dependency_1 = Dependency.create(:fieldset_child => @fieldset_child_1, :dependency_clause => @clause, :value => "5", :relationship => "equals")
      @dependency_2 = Dependency.create(:fieldset_child => @fieldset_child_2, :dependency_clause => @clause, :value => "5", :relationship => "equals")
      @input_hash = JSON.parse(@group.dependency_group_fieldset_children)
    end

    it "should return a hash object once parsed from json" do
      @input_hash.should be_a_kind_of(Hash)
    end
    it "should return an array of fieldset children that are tied to a dependency group through the dependency clause for the value" do
      lambda{@input_hash.has_value?([@fieldset_child_1.id, @fieldset_child_2.id])}.should be_true
    end
    it "should return the dependency group's fieldset child for the key" do
      @input_hash.has_key?(@fieldset_child_3.id.to_s).should be_true
    end
  end

  describe "dependent_fieldset_children method" do
    before(:each) do
      @group = DependencyGroup.new
      @group.attributes = valid_attributes
      @group.save
      @clause = DependencyClause.create(:dependency_group => @group)
      @dependency = Dependency.create(:value => 5, :relationship => "equals", :dependency_clause => @clause, :fieldset_child_id => 42)
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

  describe "to_hash" do
    before(:each) do
      @field = Field.new
      @field.stub!(:id).and_return 100

      @fieldset_child1 = FieldsetChild.new
      @fieldset_child1.stub!(:id).and_return 100
      @fieldset_child2 = FieldsetChild.new
      @fieldset_child2.stub!(:id).and_return 200

      @dependency = Dependency.new
      @dependency.stub!(:id).and_return 100
      @dependency.stub!(:fieldset_child_id).and_return @fieldset_child1.id
      @dependency.stub!(:relationship).and_return "equals"
      @dependency.stub!(:value).and_return 5

      @clause = DependencyClause.new
      @clause.stub!(:id).and_return 100

      @group = DependencyGroup.new
      @group.stub!(:id).and_return 100
      @group.stub!(:fieldset_child_id).and_return @fieldset_child2.id
      @group.stub!(:action).and_return "show"
    
      @fieldset_child1.stub!(:dependencies).and_return [@dependency]
      @dependency.stub!(:fieldset_child).and_return @fieldset_child1
      @dependency.stub!(:dependency_clause).and_return @clause
      @clause.stub!(:dependencies).and_return [@dependency]
      @clause.stub!(:dependency_group).and_return @group
      @group.stub!(:fieldset_child).and_return @fieldset_child2
      @group.stub!(:dependency_clauses).and_return [@clause]
      @fieldset_child2.stub!(:child).and_return @field
      @fieldset_child2.stub!(:child_id).and_return @field.id
    end

    it "should return a hash" do
      @group.to_hash.should be_a_kind_of Hash
    end

    it "should have a specific return structure" do
      expected_result = {
        "action" => @group.action,
        "fieldset_child_id" => @fieldset_child2.id,
        "field_id" => @field.id,
        @clause.id => {
          @dependency.id => {
            "fieldset_child_id" => @dependency.fieldset_child_id,
            "relationship" => @dependency.relationship,
            "value" => @dependency.value
          }
        }
      }

      @group.to_hash.should == expected_result
    end

    it "should have a specific return structure even with a greater complexity" do
      fieldset_child3 = FieldsetChild.new
      fieldset_child3.stub!(:id).and_return 300
      
      dependency2 = Dependency.new
      dependency2.stub!(:id).and_return 200
      dependency2.stub!(:relationship).and_return "equals"
      dependency2.stub!(:value).and_return 5
      dependency2.stub!(:fieldset_child_id).and_return fieldset_child3.id

      fieldset_child3.stub!(:dependencies).and_return [dependency2]
      dependency2.stub!(:fieldset_child).and_return fieldset_child3
      dependency2.stub!(:dependency_clause).and_return @clause
      @clause.stub!(:dependencies).and_return [@dependency, dependency2]

      expected_result = {
          "action" => @group.action,
          "fieldset_child_id" => @group.fieldset_child_id,
          "field_id" => @field.id,
          @clause.id => {
            @dependency.id => {
              "fieldset_child_id" => @dependency.fieldset_child_id,
              "relationship" => @dependency.relationship,
              "value" => @dependency.value
            },
            dependency2.id => {
              "fieldset_child_id" => dependency2.fieldset_child_id,
              "relationship" => dependency2.relationship,
              "value" => dependency2.value
            }
          }
      }

      @group.to_hash.should == expected_result
    end

  end

end
