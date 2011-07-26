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
    before(:each) do
      @field = Field.new
    end

    it "should return true if the field type requires options" do
      @field.type = "select"
      @field.options?.should be_true
    end

    it "should return false if the field does not have options" do
      @field.type = "textfield"
      @field.options?.should be_false
    end
  end

  describe "options" do
    it "should return options from the field options table" do
      field = Field.new
      field.should_receive(:field_options).and_return(["array of stuff"])
      field.options.should include "array of stuff"
    end
  end

  describe "has_defaults?" do
    before(:each) do
      @field = Field.new
    end

    it "should return true if the field default has a value" do
      @field.should_receive(:field_defaults).and_return(["default value"])
      @field.has_defaults?.should be_true
    end
    it "should return false if the field default has no values" do
      @field.should_receive(:field_defaults).and_return([])
      @field.has_defaults?.should be_false
    end
  end

  describe "defaults" do
    before(:each) do
      @field = Field.new
    end


    it "should return a single value if the type does not support multiple options" do
      @field.stub!(:options?).and_return(false)
      @field.should_receive(:field_defaults).and_return(["default value"])
      @field.defaults.should == "default value"
    end

    it "should return nil if the type does not support multiple options" do
      @field.stub!(:options?).and_return(false)
      @field.should_receive(:field_defaults).and_return([])
      @field.defaults.should be_nil
    end

    it "may not work because it should be looking at field_defaults" do
      @field.stub!(:options?).and_return(false)
      @field.should_receive(:field_defaults).and_return(["default value"])
      @field.defaults.should include "default value"
    end

    it "may not work because it should be looking at field_defaults" do
      @field.stub!(:options?).and_return(false)
      @field.should_receive(:field_defaults).and_return([])
      @field.defaults.should be_nil
    end
  end
end