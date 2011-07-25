require 'spec_helper'
include DynamicFieldsets

describe FieldsetAssociator do
  include FieldsetAssociatorHelper
  
  it "should respond to fieldset" do
    FieldsetAssociator.new.should respond_to :fieldset
  end

  describe "validations" do
    before(:each) do
      @fsa = FieldsetAssociator.new
    end

    it "should be valid" do
      @fsa.attributes = valid_attributes
      @fsa.should be_valid
    end

    it "should require a fieldset" do
      @fsa.should have(1).error_on(:fieldset_id)
    end

    it "should require a field model id" do
      @fsa.should have(1).error_on(:fieldset_model_id)
    end

    it "should require a field model type" do
      @fsa.should have(1).error_on(:fieldset_model_type)
    end

    it "should require a field model name" do
      @fsa.should have(1).error_on(:fieldset_model_name)
    end

    it "should error require a unique field model, field model name pair" do
      @fsa.attributes = valid_attributes
      @fsa.save
      fsa2 = FieldsetAssociator.new
      fsa2.should have(1).error_on(:fieldset_model_name)
    end
  end

  describe "find_by_fieldset_model_parameters" do
  
    it "should respond to find_by_fieldset_model_parameters"

  end
end
