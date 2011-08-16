require 'spec_helper'
include DynamicFieldsets

describe FieldsetChild do
  include FieldsetChildHelper

  it "should respond to fieldset" do
    FieldsetChild.new.should respond_to :fieldset
  end

  it "should respond to child" do
    FieldsetChild.new.should respond_to :child
  end

  it "should respond to order_num" do
    FieldsetChild.new.should respond_to :order_num
  end

  describe "validations" do
    before(:each) do
      @fieldset_child = FieldsetChild.new
    end
    it "are valid" do
      @fieldset_child.attributes = valid_attributes
      @fieldset_child.should be_valid
    end
    
    it "require fieldset" do
      @fieldset_child.should have(1).error_on(:fieldset_id)
    end

    it "require child" do
      @fieldset_child.should have(1).error_on(:child_id)
      @fieldset_child.should have(1).error_on(:child_type)
    end

    it "require order_num" do
      @fieldset_child.stub!(:assign_order)
      @fieldset_child.should have(1).error_on(:order_num)
    end

    it "require child_type to be only either 'field' or fieldset'" do
      pending
    end
    
    it "do not allow duplicate pairings of fieldsets and fields" do
      fieldset = Fieldset.new
      field = Field.new
      field.stub!(:id).and_return(100)
      fieldset_child1 = FieldsetChild.new(:fieldset => fieldset, :child => field, :order_num => 1)
      fieldset_child1.stub!(:id).and_return(100)
      fieldset_child2 = FieldsetChild.new(:fieldset => fieldset, :child => field, :order_num => 2)
      FieldsetChild.stub!(:where).and_return([fieldset_child1])
      fieldset_child2.should have(1).error_on(:child_id)
    end

    # this should have two errors, because it's also a loop
    it "cannot be it's own parent" do
      fieldset = Fieldset.new
      fieldset.stub!(:id).and_return(100)
      fieldset_child = FieldsetChild.new(:fieldset_id => fieldset.id, :child => fieldset, :order_num => 1)
      fieldset_child.should have(2).error_on(:child_id)
    end
  
    it "should not allow a parent fieldset when it would create a cycle" do
      fieldset1 = Fieldset.new
      fieldset1.stub!(:id).and_return(100)
      fieldset2 = Fieldset.new
      fieldset2.stub!(:id).and_return(200)
      fieldset3 = Fieldset.new
      fieldset3.stub!(:id).and_return(300)
      fieldset_child1 = FieldsetChild.create(:fieldset_id => fieldset1.id, :child => fieldset2, :order_num => 1)
      fieldset_child2 = FieldsetChild.create(:fieldset_id => fieldset2.id, :child => fieldset3, :order_num => 1)
      fieldset_child3 = FieldsetChild.new(:fieldset_id => fieldset3.id, :child => fieldset1, :order_num => 1)
      fieldset_child3.should have(1).error_on(:child_id)
    end
  end

end
