require 'spec_helper'
include DynamicFieldsets

describe FieldRecord do
  include FieldRecordHelper

  describe "updates with multiple use fields" do
    it "should replace fieldset_id with fieldset_child_id"
  end

  it "should respond to field" do
    FieldRecord.new.should respond_to :field
  end

  it "should respond to fieldset_associator" do
    FieldRecord.new.should respond_to :fieldset_associator
  end

  describe "validations" do
    before(:each) do
      @field_record = FieldRecord.new
    end
    
    it "should be valid" do
      @field_record.field = Field.new
      @field_record.fieldset_associator = FieldsetAssociator.new
      @field_record.value = "42"
      @field_record.should be_valid
    end

    it "should require field" do
      @field_record.should have(1).error_on(:field)
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
  end
end
