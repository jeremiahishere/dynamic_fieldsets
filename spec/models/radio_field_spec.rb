require 'spec_helper'

describe DynamicFieldsets::RadioField do
  before do
    @radio = DynamicFieldsets::RadioField.new
  end
  subject { @radio }

  describe "mixins" do
    it "should include the field options mixin" do
      @radio.class.should respond_to :acts_as_field_with_field_options
    end
    it "should include the single answer mixin" do
      @radio.class.should respond_to :acts_as_field_with_single_answer
    end
  end

  # instance methods
  #
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
      @radio.form_partial_locals(@attributes)[:fsa].should == @fsa
      @radio.form_partial_locals(@attributes)[:fieldset_child].should == @fsc
    end
  end
end
