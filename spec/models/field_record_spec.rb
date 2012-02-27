require 'spec_helper'

describe DynamicFieldsets::FieldRecord do
  include FieldRecordHelper

  it "should respond to field" do
    DynamicFieldsets::FieldRecord.new.should respond_to :field
  end

  it "should respond to fieldset_associator" do
    DynamicFieldsets::FieldRecord.new.should respond_to :fieldset_associator
  end

  describe "validations" do
    before(:each) do
      @field_record = DynamicFieldsets::FieldRecord.new
    end
    
    it "should be valid" do
      @field_record.fieldset_child = DynamicFieldsets::FieldsetChild.new
      @field_record.fieldset_associator = DynamicFieldsets::FieldsetAssociator.new
      @field_record.value = "42"
      child = mock_model(DynamicFieldsets::Field)
      @field_record.fieldset_child = DynamicFieldsets::FieldsetChild.new(:child => child)
      @field_record.should be_valid
    end

    it "should require field" do
      @field_record.should have(1).error_on(:fieldset_child)
    end

    it "should require fieldset_associator" do
      @field_record.should have(1).error_on(:fieldset_associator)
    end

    it "should require value" do
      @field_record.should have(1).error_on(:value)
    end

    it "should not error if value is a blank string" do
      @field_record.value = ""
      @field_record.should have(0).error_on(:value)
    end

    it "should error if the fieldset_child has the wrong type" do
      child = mock_model(DynamicFieldsets::Fieldset)
      @field_record.fieldset_child = DynamicFieldsets::FieldsetChild.new(:child => child)
      @field_record.valid?
      @field_record.should have(1).error_on(:fieldset_child)
    end
  end
end
