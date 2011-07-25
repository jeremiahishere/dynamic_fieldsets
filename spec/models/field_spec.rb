require 'spec_helper'
include DynamicFieldsets

describe Field do
  include FieldHelper

  it "should respond to fieldset"
  it "should respond to field_options"
  it "should respond to field_defaults"
  it "should respond to field_html_attributes"

  describe "validations" do

    it "should be valid"
    it "should require name"
    it "should require label"
    it "should require type"
    it "should require order number"
    it "should require type within the allowable types"
    it "should require options if the type is one that requires options"
    it "should probably also check required and enabled is within true/false"
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
