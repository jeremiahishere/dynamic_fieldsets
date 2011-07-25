require 'spec_helper'

include DynamicFieldsets

describe DynamicFieldsetsInModel do
  it "should respond to acts_as_dynamic_fieldset"

  it "should respond to fieldset_associator"
  it "should respond to fieldset"

  describe "acts_as_dynamic_fieldset class method" do
    it "should initialize the dynamic_fieldsets field"
    it "should include the instance methods"
  end

  describe "method missing method" do
    it "should call match_fieldset_associator?"
    it "should call fieldset_associator if match_fieldset_associator? returns true"
    it "should call match_fieldset?"
    it "should call fieldset if match_fieldset? returns true"
  end

  describe "respond_to? method" do
    it "should call match_fieldset_associator?"
    it "should call match_fieldset?"
  end

  describe "match_fieldset_associator? method" do
    it "should call dynamic_fieldsets"
    it "should return true if the sym parameter matches a key in dynamic_fieldsets"
    it "should return false if the sym parameter does not match a key in dynamic_fieldsets"
  end

  # need to be abvle to call child_form_fieldset to get the fieldset object
  # because child_form does not exist in the fsa model until after it is created
  describe "match_fieldset? method" do
    it "should call dynamic_fieldsets"
    it "should return true if the sym parameter matches a key in dynamic_fieldsets followed by the word fieldset"
    it "should return false if the sym parameter does not match a key in dynamic_fieldsets followed by the word fieldset"
    it "should return false if the sym parameter matches a key in dynamic_fieldsets not followed by the word fieldset"
  end

  describe "fieldset_associator method" do
    it "should return the fieldset associator object for the specified dynamic fieldset"
    it "should return nil if the sym param does not match a kyer in the dynamic_fieldsets field"
  end

  describe "fieldset method" do
    it "should return the fieldset object for the specified dynamic fieldset"
    it "should return nil if the sym param does not match a kyer in the dynamic_fieldsets field"
  end
end
