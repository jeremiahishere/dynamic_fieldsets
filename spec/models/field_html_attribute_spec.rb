require 'spec_helper'
include DynamicFieldsets
  
describe FieldHtmlAttribute do
  include FieldHtmlAttributeHelper

  it "should respond to field" do
    field_html_attribute = FieldHtmlAttribute.new
    field_html_attribute.should respond_to :field
  end
  
  describe "validations" do
    before(:each) do
      @field_html_attribute = FieldHtmlAttribute.new
    end

    it "should be valid" do
      @field_html_attribute.attributes = valid_attributes
      @field_html_attribute.should be_valid
    end

    it "should require an attribute" do
      @field_html_attribute.should have(1).error_on(:attribute_name)
    end
    
    it "should require a value" do
      @field_html_attribute.should have(1).error_on(:value)
    end
  end  
end
