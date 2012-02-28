require 'spec_helper'

describe DynamicFieldsets::InstructionField do
  it "needs tests"
  before do
    @instruction = DynamicFieldsets::InstructionField.new
  end
  subject { @instruction }

  # instance methods

  describe ".show_partial" do
    it "should use the intstruction show partial" do
      @instruction.show_partial.should == "/dynamic_fieldsets/show_partials/show_instruction"
    end
  end

  describe ".use_form_header_partial?" do
    it "should return false" do
      @instruction.use_form_header_partial?.should be_false
    end
  end

  describe ".use_form_footer_partial?" do
    it "should return false" do
      @instruction.use_form_footer_partial?.should be_false
    end
  end

  describe ".form_partial_locals" do
    it "should call super"
    it "should set the label"
  end

  describe ".update_field_records" do
    it "should do nothing"
  end
end
