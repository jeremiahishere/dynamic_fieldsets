require 'spec_helper'

include DynamicFieldsets

describe FieldWithFieldOptions do
  it "should not use CheckboxField to test the mixin" do
    pending "needs to use it's own class"
  end

  describe "class methods" do
    it { DynamicFieldsets::CheckboxField.should respond_to :acts_as_field_with_field_options }
  end

  describe "validations" do
    it "should call at_least_one_field_option"
  end

  describe "instance methods" do
    before do
      @field = DynamicFieldsets::CheckboxField.new
    end
    subject { @field }

    it { should respond_to :collect_field_records_by_fsa_and_fsc }
    describe "collect_field_records_by_fsa_and_fsc" do
      it "needs tests"
    end

    it { should respond_to :get_value_for_show }
    describe ".get_value_for_show" do
      it "needs tests"
    end

    it { should respond_to :uses_field_options? }
    describe ".uses_field_options?" do
      it "needs tests"
    end

    it { should respond_to :at_least_one_field_option }
    describe ".at_least_one_field_option" do
      it " needs tests"
    end

    it { should respond_to :options }
    describe ".options" do
      it "needs tests"
    end
  end


  describe "options" do
    before do
      pending "This code has been moved here from the field model"
    end

    it "should return options from the field options table if enabled" do
      field = DynamicFieldsets::Field.new
      field_option = mock_model(DynamicFieldsets::FieldOption)
      field_option.stub!(:enabled).and_return(true)
      field.should_receive(:field_options).and_return([field_option])
      field.options.should include field_option
    end
    it "should not return disabled options from the field options table" do
      field = DynamicFieldsets::Field.new
      field_option = mock_model(DynamicFieldsets::FieldOption)
      field_option.stub!(:enabled).and_return(false)
      field.should_receive(:field_options).and_return([field_option])
      field.options.should_not include field_option
    end
  end
end
