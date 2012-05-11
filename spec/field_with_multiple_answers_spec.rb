require 'spec_helper'

include DynamicFieldsets

describe FieldWithMultipleAnswers do
  it "should not use CheckboxField to test the mixin" do
    pending "needs to use it's own class"
  end

  describe "class methods" do
    it { DynamicFieldsets::CheckboxField.should respond_to :acts_as_field_with_multiple_answers }
  end

  describe "instance methods" do
    before do
      @field = DynamicFieldsets::CheckboxField.new
    end
    subject { @field }

    it { should respond_to :show_partial_locals }
    describe ".show_partial_locals" do
      it "needs tests"
    end

    it { should respond_to :update_field_records }
    describe ".update_field_records" do
      it "needs tests"
    end

    it { should respond_to :get_values_using_fsa_and_fsc }
    describe ".get_values_using_fsa_and_fsc" do
      it "needs tests"
    end

    it { should respond_to :show_partial }
    describe ".show_partial" do
      it "needs tests"
    end

    it { should respond_to :defaults }
    describe ".defaults" do
      it "needs tests"
    end

    it { should respond_to :values_or_defaults_for_form }
    describe ".values_or_defaults_for_form" do
      it "needs tests"
    end
  end

  describe "defaults" do
    before(:each) do
      pending "this code has been moved from the field model"
      @field = DynamicFieldsets::Field.new
    end

    it "should return an array if the type supports multiple options" do
      @field.stub!(:options?).and_return(true)
      @field.should_receive(:field_defaults).and_return(["default value"])
      @field.defaults.should == ["default value"]
    end

    it "should return nil if the type does not support multiple options" do
      @field.stub!(:options?).and_return(false)
      @field.defaults.should be_nil
    end
  end
end
