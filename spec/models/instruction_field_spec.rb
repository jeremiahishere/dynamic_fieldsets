require 'spec_helper'

describe DynamicFieldsets::InstructionField do
  before do
    @instruction = DynamicFieldsets::InstructionField.create(:name => "test", :label => "test")
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
    before (:all) do
      @fsa = DynamicFieldsets::FieldsetAssociator.new
      @fsa.stub!(:id).and_return(1)
      @fsc = DynamicFieldsets::FieldsetChild.new
      @fsc.stub!(:id).and_return(1)
      @attributes = {:fsa => @fsa, :fieldset_child => @fsc, :values => [], :value => nil}
    end

    it "should call super" do
      # fsa and fsc are set in the superclass (Field) form_partial_locals method
      @instruction.form_partial_locals(@attributes)[:fsa].should == @fsa
      @instruction.form_partial_locals(@attributes)[:fieldset_child].should == @fsc
    end
    it "should set the label" do
      @instruction.form_partial_locals(@attributes)[:label].should == @instruction.label
    end
  end

  describe ".update_field_records" do
    it "should do nothing" do end
  end
end
