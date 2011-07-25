require 'spec_helper'
include DynamicFieldsets

describe Field do
  include FieldHelper

  it "should respond to fieldset" do
    Field.new.should respond_to :fieldset
  end

  it "should respond to field_options" do
    Field.new.should respond_to :field_options
  end

  it "should respond to field_defaults" do
    Field.new.should respond_to :field_defaults
  end

  it "should respond to field_html_attributes" do
    Field.new.should respond_to :field_html_attributes
  end

  describe "validations" do
    before(:each) do
      @field = Field.new
    end

    it "should be valid" do
      @field.attributes = valid_attributes
      # hack to set the type, not sure why it is needed
      @field.type = "textfield"
      @field.should be_valid
    end

    it "should require name" do
      @field.should have(1).error_on(:name)
    end
    
    it "should require label" do
      @field.should have(1).error_on(:label)
    end

    it "should require type" do
      @field.should have(2).error_on(:type)
    end

    it "should require order number" do
      @field.should have(1).error_on(:order_num)
    end

    it "should require type within the allowable types" do
      @field.type = "unsupported_type"
      @field.should have(1).error_on(:type)
    end

    it "should require type within the allowable types" do
      @field.type = "select"
      @field.should have(0).error_on(:type)
    end


    it "should require enabled true or false" do
      @field.enabled = true
      @field.should have(0).error_on(:enabled)
    end

    it "should require enabled" do
      @field.enabled = nil
      @field.should have(2).error_on(:enabled)
    end

    it "should require required true or false" do
      @field.required = true
      @field.should have(0).error_on(:required)
    end

    it "should require required" do
      @field.required = nil
      @field.should have(2).error_on(:required)
    end

    it "should require options if the type is one that requires options" do
      @field.type = "select"
      @field.should have(1).error_on(:field_options)
    end
  end

  describe "options?" do
    it "should return true if the field requires options"
    it "shoudl return false if the field does not have options"
  end

  describe "options" do
    it "should return options from the field options table"
  end

  describe "required?" do
    it "is this necessary?"
  end

  describe "enabled?" do
    it "is this necessary?"
  end

  describe "has_default?" do
    it "should return true if the field default has a value"
    it "shoudl return flase if the field default has no values"
  end

  describe "default" do
    it "should return a single value for the field default"
    it "may not work because it should be looking at field_defaults"
  end
end
