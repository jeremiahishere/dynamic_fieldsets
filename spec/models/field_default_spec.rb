require 'spec_helper'
include DynamicFieldsets
  
describe FieldDefault do
  include FieldDefaultHelper

  it "should respond to field" do
    field_default = FieldDefault.new
    field_default.should respond_to :field
  end
  
  describe "validations" do
    before(:each) do
      @field_default = FieldDefault.new
    end

    it "should be valid" do
      @field_default.attributes = valid_attributes
      @field_default.should be_valid
    end

    it "should require a label" do
      @field_default.should have(1).error_on(:value)
    end
  end  
end
