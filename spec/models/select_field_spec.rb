require 'spec_helper'

describe DynamicFieldsets::SelectField do
  before do
    @select = DynamicFieldsets::SelectField.create(:name => "test", :label => "test")
  end
  subject { @select }

  describe "mixins" do
    it "should include the field options mixin" do
      @select.class.should respond_to :acts_as_field_with_field_options
    end
    it "should include the multiple answers mixin" do
      @select.class.should respond_to :acts_as_field_with_single_answer
    end
  end

  # instance methods

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
      @select.form_partial_locals(@attributes)[:fsa].should == @fsa
      @select.form_partial_locals(@attributes)[:fieldset_child].should == @fsc
    end

    it "should call value_or_default_for_form" do
      @select.should_receive(:value_or_default_for_form)
      @select.form_partial_locals(@attributes)
    end
    
    it "should include selected_id and collection" do
      @select.form_partial_locals(@attributes)[:selected_id].should be_true
      @select.form_partial_locals(@attributes)[:collection].should be_true
    end
  end
end
