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
end
