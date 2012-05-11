require 'spec_helper'

include DynamicFieldsets

describe DynamicFieldsets::FieldWithSingleAnswer do

  it "should not use TextField to test the mixin" do
    pending "needs to use it's own class"
  end

  describe "class methods" do
    it { DynamicFieldsets::TextField.should respond_to :acts_as_field_with_single_answer }
  end

  describe "instance methods" do
    before do
      @field = DynamicFieldsets::TextField.new
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

    it { should respond_to :default }
    describe ".default" do
      it "needs tests"
    end

    it { should respond_to :value_or_default_for_form }
    describe ".value_or_default_for_form" do
      it "needs tests"
    end
  end

  describe "default" do
    before(:each) do
      pending "this code has been moved from the field model"
      @field = DynamicFieldsets::Field.new
    end

    it "should return a string if the type does not support multiple options" do
      @field.stub!(:options?).and_return(false)
      @field.should_receive(:field_defaults).and_return(["default value"])
      @field.default.should == "default value"
    end

    it "should return nil if the type supports multiple options" do
      @field.stub!(:options?).and_return(true)
      @field.default.should be_nil
    end
  end 

end
