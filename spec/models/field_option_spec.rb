require 'spec_helper'
include DynamicFieldsets
  
describe FieldOption do
  include FieldOptionHelper

  it "should respond to field" do
    field_option = FieldOption.new
    field_option.should respond_to :field
  end
  
  describe "validations" do
    before(:each) do
      @field_option = FieldOption.new
    end

    it "should be valid" do
      @field_option.attributes = valid_attributes
      @field_option.should be_valid
    end

    it "should require a label" do
      @field_option.should have(1).error_on(:label)
    end
  end  
end
