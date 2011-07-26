require 'spec_helper'
include DynamicFieldsets

describe FieldsetAssociator do
  include FieldsetAssociatorHelper
  
  it "should respond to fieldset" do
    FieldsetAssociator.new.should respond_to :fieldset
  end

  it "should respond to field_records" do
    FieldsetAssociator.new.should respond_to :field_records
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
    before(:each) do
      @fieldset = mock_model(Fieldset)
      @fieldset.stub!(:nkey).and_return(":hire_form")
      @fieldset.stub!(:id).and_return(1)
      @fsa = FieldsetAssociator.create(valid_attributes)

      @fieldset_model_attributes = valid_attributes
      @fieldset_model_attributes[:fieldset] = :hire_form
    end
  
    it "should respond to find_by_fieldset_model_parameters" do
      FieldsetAssociator.should respond_to :find_by_fieldset_model_parameters
    end

    it "should call Fieldset find_by_nkey" do
      Fieldset.should_receive(:find_by_nkey).and_return(@fieldset)
      FieldsetAssociator.find_by_fieldset_model_parameters(@fieldset_model_attributes)
    end

    it "should return the correct fieldset associator" do
      Fieldset.stub!(:find_by_nkey).and_return(@fieldset)
      # this is a fun hack because of all the fsas being made during tests
      FieldsetAssociator.find_by_fieldset_model_parameters(@fieldset_model_attributes).should include @fsa
    end
  end

  describe "field_values method" do
    before(:each) do
      @fsa = FieldsetAssociator.new
    end

    it "should return a hash"  do
      @field = mock_model(DynamicFieldsets::Field)
      @field.stub!(:id).and_return(37)
      @field_record = mock_model(DynamicFieldsets::FieldRecord)
      @field_record.stub!(:field).and_return(@field)
      @field_record.stub!(:value).and_return("forty two")

      @fsa.field_values.should be_a_kind_of Hash
      @fsa.stub!(:field_records).and_return([@field_record, @field_record])
    end

    it "should call field_records" do
      @fsa.should_receive(:field_records)
      @fsa.field_values
    end

    it "should return multiple select values as an array" do
      @field.stub!(:type).and_return("multiple_select")
      @fsa.field_values.should == { 37 => ["forty two"] }
    end

    it "should return checkboxes values as an array" do
      @field.stub!(:type).and_return("checkbox")
      @fsa.field_values.should == { 37 => ["forty two"] }
    end

    it "should return all other field types as strings" do
      @field.stub!(:type).and_return("text")
      @fsa.field_values.should == { 37 => "forty two" }
    end
  end
end
