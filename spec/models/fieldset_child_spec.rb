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
    it "should be valid" do
      @fieldset_child.attributes = valid_attributes
      @fieldset_child.should be_valid?
    end
    
    it "should require fieldset" do
      @fieldset_child.should have(1).error_on(:fieldset_id)
    end

    it "should require child" do
      @fieldset_child.should have(1).error_on(:child_id)
      @fieldset_child.should have(1).error_on(:child_type)
    end

    it "should require order number" do
      @fieldset_child.should have(1).error_on(:order_num)
    end

    it "should only allow one field per fieldset" do
      pending "doing this one later"
    end

    it "cannot be it's own parent"
  end

end
