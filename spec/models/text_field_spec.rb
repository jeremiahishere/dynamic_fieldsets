require 'spec_helper'

describe DynamicFieldsets::TextField do
  before do
    @text = DynamicFieldsets::TextField.new
  end
  subject { @text }

  describe "mixins" do
    it "should include the single answer mixin" do
      @text.class.should respond_to :acts_as_field_with_single_answer
    end
  end

  # instance methods

  describe "form_partial_locals" do
    before (:all) do
      @fsa = DynamicFieldsets::FieldsetAssociator.new
      @fsa.stub!(:id).and_return(1)
      @fsc = DynamicFieldsets::FieldsetChild.new
      @fsc.stub!(:id).and_return(1)
      @attributes = {:fsa => @fsa, :fieldset_child => @fsc, :values => [], :value => nil}
    end

    it "should call super" do
      # fsa and fsc are set in the superclass (Field) form_partial_locals method
      @text.form_partial_locals(@attributes)[:fsa].should == @fsa
      @text.form_partial_locals(@attributes)[:fieldset_child].should == @fsc
    end
    it "should call value_or_default_for_form" do
      @text.should_receive(:value_or_default_for_form)
      @text.form_partial_locals(@attributes)
    end
  end
end
