require 'spec_helper'

describe DynamicFieldsets::FieldOption do
  include FieldOptionHelper

  it "should respond to field" do
    field_option = DynamicFieldsets::FieldOption.new
    field_option.should respond_to :field
  end
  
  describe "validations" do
    before(:each) do
      @field_option = DynamicFieldsets::FieldOption.new
    end

    it "should be valid" do
      @field_option.attributes = valid_attributes
      @field_option.should be_valid
    end

    it "should require a name" do
      @field_option.should have(1).error_on(:name)
    end
    it "should require enabled is a boolean value" do
      @field_option.enabled = nil 
      @field_option.should have(1).error_on(:enabled)
    end
  end  

  describe "enabled scope" do
    before(:each) do
      @field_option1 = DynamicFieldsets::FieldOption.new
      @field_option1.attributes = valid_attributes
      @field_option1.enabled = true
      @field_option1.save

      @field_option2 = DynamicFieldsets::FieldOption.new
      @field_option2.attributes = valid_attributes
      @field_option2.enabled = false
      @field_option2.save
    end

    it "should return enabled field options" do
      DynamicFieldsets::FieldOption.enabled.should include @field_option1
    end

    it "should not return disabled field options" do
      DynamicFieldsets::FieldOption.enabled.should_not include @field_option2
    end
  end
end
