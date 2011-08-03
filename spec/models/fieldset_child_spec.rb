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
      @fieldset_child.should be_valid
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

    it "should only not allow duplicate entries of the same field" do
      pending "to be done by hex"
      fieldset = Fieldset.new(:nkey => "parent fieldset")
      field = Field.new
    end

    it "cannot be it's own parent"
      pending "to be done by hex"
    end
  
    it "should not allow a parent fieldset when it would create a cycle" do
      pending "to be finished by hex"
      fieldset1 = Fieldset.new(:nkey => "fieldset1")
      fieldset2 = Fieldset.new(:parent_fieldset => fieldset1, :nkey => "fieldset2")
      fieldset3 = Fieldset.new(:parent_fieldset => fieldset2, :nkey => "fieldset3")
      fieldset1.parent_fieldset = fieldset3

      fieldset1.should have(1).error_on(:parent_fieldset)
    end
  end

end
