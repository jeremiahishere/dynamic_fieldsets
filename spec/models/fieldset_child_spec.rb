require 'spec_helper'
include DynamicFieldsets

describe FieldsetChild do
  #include FieldsetChildHelper

  it "should respond to field"
  it "should respond to order_num"
  it "should respond to child"

  describe "validations" do
    it "should require field"
    it "should require child"
    it "should require order number"
    it "should only allow one field per fieldset"
  end

end
